import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart' as mime_lib;
import 'package:path/path.dart' as p;

import '../../../../core/network/api_exception.dart';
import '../../data/dto/request_media_upload_request_dto.dart';
import '../../data/media_conversion_service.dart';
import '../../data/media_format_validator.dart';
import '../../data/media_repository.dart';
import 'media_upload_state.dart';
import 'upload_task.dart';

class MediaUploadCubit extends Cubit<MediaUploadState> {
  MediaUploadCubit(
    this._repository,
    this._conversionService,
    this.workOrderId,
  ) : super(const MediaUploadState());

  final IMediaRepository _repository;
  final IMediaConversionService _conversionService;
  final int workOrderId;

  int _nextId = 0;
  void Function()? onUploadConfirmed;

  Future<void> enqueueFiles(List<String> filePaths, String stage) async {
    final newTasks = <UploadTask>[];

    for (final path in filePaths) {
      final info = MediaFormatValidator.classify(path);
      final task = UploadTask(
        id: _nextId++,
        originalPath: path,
        fileName: p.basename(path),
        stage: stage,
        kind: info?.kind ?? MediaKind.photo,
        status: info == null ? UploadTaskStatus.error : UploadTaskStatus.queued,
        errorMessage: info == null
            ? 'Desteklenmeyen dosya formatı. JPEG, PNG, HEIC, MP4 veya MOV kullanın.'
            : null,
      );
      newTasks.add(task);
    }

    emit(MediaUploadState(tasks: [...state.tasks, ...newTasks]));

    for (final task in newTasks) {
      if (task.status == UploadTaskStatus.queued) {
        await _process(task.id);
      }
    }
  }

  Future<void> retry(int taskId) => _process(taskId);

  Future<void> _process(int taskId) async {
    var task = state.tasks.firstWhere((t) => t.id == taskId);
    final info = MediaFormatValidator.classify(task.originalPath);
    if (info == null) {
      _updateTask(
        task.copyWith(
          status: UploadTaskStatus.error,
          errorMessage:
              'Desteklenmeyen dosya formatı. JPEG, PNG, HEIC, MP4 veya MOV kullanın.',
        ),
      );
      return;
    }

    try {
      File file = File(task.originalPath);
      var mimeType = info.targetMimeType;

      if (info.needsConversion) {
        _updateTask(task.copyWith(status: UploadTaskStatus.converting));
        file = info.kind == MediaKind.photo
            ? await _conversionService.convertHeicToJpeg(file)
            : await _conversionService.convertToMp4(file);
      } else {
        mimeType = mime_lib.lookupMimeType(task.originalPath) ?? info.targetMimeType;
      }

      final sizeBytes = await file.length();
      final maxBytes = MediaFormatValidator.maxBytesFor(info.kind);
      if (sizeBytes > maxBytes) {
        final maxMb = maxBytes ~/ (1024 * 1024);
        _updateTask(
          task.copyWith(
            status: UploadTaskStatus.error,
            errorMessage: 'Dosya çok büyük (maksimum $maxMb MB).',
          ),
        );
        return;
      }

      final uploadResponse = await _repository.requestUpload(
        workOrderId,
        RequestMediaUploadRequestDto(
          mediaType: info.kind == MediaKind.photo ? 'PHOTO' : 'VIDEO',
          stage: task.stage,
          fileName: p.basename(file.path),
          mimeType: mimeType,
          sizeBytes: sizeBytes,
        ),
      );

      task = task.copyWith(status: UploadTaskStatus.uploading, progress: 0);
      _updateTask(task);

      await _repository.uploadFile(
        uploadResponse.uploadUrl,
        file,
        mimeType,
        onProgress: (sent, total) {
          if (total > 0) {
            _updateTask(task.copyWith(progress: sent / total));
          }
        },
      );

      _updateTask(task.copyWith(status: UploadTaskStatus.confirming));
      await _repository.confirmUpload(workOrderId, uploadResponse.mediaFileId);

      _updateTask(task.copyWith(status: UploadTaskStatus.done, progress: 1));
      if (!isClosed) {
        onUploadConfirmed?.call();
      }
    } on MediaConversionException catch (e) {
      _updateTask(
        task.copyWith(status: UploadTaskStatus.error, errorMessage: e.message),
      );
    } on ApiException catch (e) {
      _updateTask(
        task.copyWith(
          status: UploadTaskStatus.error,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }

  void _updateTask(UploadTask updated) {
    if (isClosed) return;
    final tasks = state.tasks
        .map((task) => task.id == updated.id ? updated : task)
        .toList();
    emit(MediaUploadState(tasks: tasks));
  }
}
