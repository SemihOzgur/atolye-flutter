import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;

import '../../../../core/network/api_exception.dart';
import '../../data/archive_integrity_checker.dart';
import '../../data/archive_repository.dart';
import '../../data/dto/archive_candidate_dto.dart';
import '../../data/dto/archive_media_item_dto.dart';
import 'archive_state.dart';
import 'archive_task.dart';

class ArchiveCubit extends Cubit<ArchiveState> {
  ArchiveCubit(this._repository, this._integrityChecker)
      : super(const ArchiveState());

  final IArchiveRepository _repository;
  final ArchiveIntegrityChecker _integrityChecker;

  Future<void> loadCandidates({int? olderThanDays}) async {
    final days = olderThanDays ?? state.olderThanDays;
    emit(
      state.copyWith(
        listStatus: ArchiveListStatus.loading,
        olderThanDays: days,
      ),
    );

    try {
      final candidates = await _repository.fetchCandidates(
        olderThanDays: days,
      );
      emit(
        state.copyWith(
          listStatus: ArchiveListStatus.loaded,
          candidates: candidates,
          selectedWorkOrderIds: const <int>{},
        ),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          listStatus: ArchiveListStatus.error,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }

  void toggleSelection(int workOrderId) {
    final updated = Set<int>.from(state.selectedWorkOrderIds);
    if (!updated.remove(workOrderId)) {
      updated.add(workOrderId);
    }
    emit(state.copyWith(selectedWorkOrderIds: updated));
  }

  void setTargetRoot(String path) {
    emit(state.copyWith(targetRootPath: path));
  }

  Future<void> archiveSelected() async {
    if (!state.canArchive) return;

    final targetRoot = state.targetRootPath!;
    final selected = state.candidates
        .where((c) => state.selectedWorkOrderIds.contains(c.workOrderId))
        .toList();

    emit(
      state.copyWith(
        isArchiving: true,
        tasks: selected
            .map(
              (c) => ArchiveTask(
                workOrderId: c.workOrderId,
                orderNumber: c.orderNumber,
                totalMediaCount: c.mediaCount,
              ),
            )
            .toList(),
      ),
    );

    for (final candidate in selected) {
      await _processCandidate(candidate, targetRoot);
    }

    emit(state.copyWith(isArchiving: false));
    await loadCandidates();
  }

  Future<void> _processCandidate(
    ArchiveCandidateDto candidate,
    String targetRoot,
  ) async {
    _updateTask(
      candidate.workOrderId,
      (t) => t.copyWith(status: ArchiveTaskStatus.exporting),
    );

    List<ArchiveMediaItemDto> items;
    try {
      items = (await _repository.export(candidate.workOrderId)).items;
    } on ApiException catch (e) {
      _updateTask(
        candidate.workOrderId,
        (t) => t.copyWith(
          status: ArchiveTaskStatus.error,
          errorMessage: e.detail ?? e.message,
        ),
      );
      return;
    }

    if (items.isEmpty) {
      _updateTask(
        candidate.workOrderId,
        (t) => t.copyWith(
          status: ArchiveTaskStatus.done,
          resultSummary: 'Bu iş emrinde arşivlenecek medya bulunamadı.',
        ),
      );
      return;
    }

    final verifiedIds = <int>[];

    for (final item in items) {
      _updateTask(
        candidate.workOrderId,
        (t) => t.copyWith(
          status: ArchiveTaskStatus.downloading,
          currentFileName: item.fileName,
        ),
      );

      final destinationPath = _buildDestinationPath(
        targetRoot,
        candidate,
        item,
      );

      try {
        await Directory(p.dirname(destinationPath)).create(recursive: true);
        final etag = await _repository.downloadToFile(
          item.downloadUrl,
          destinationPath,
        );
        final localMd5 = await _integrityChecker.computeMd5(
          File(destinationPath),
        );

        if (_integrityChecker.matches(localMd5, etag)) {
          verifiedIds.add(item.mediaId);
          _updateTask(
            candidate.workOrderId,
            (t) => t.copyWith(verifiedCount: t.verifiedCount + 1),
          );
        } else {
          await _deleteIfExists(destinationPath);
          _updateTask(
            candidate.workOrderId,
            (t) => t.copyWith(failedCount: t.failedCount + 1),
          );
        }
      } catch (_) {
        await _deleteIfExists(destinationPath);
        _updateTask(
          candidate.workOrderId,
          (t) => t.copyWith(failedCount: t.failedCount + 1),
        );
      }
    }

    if (verifiedIds.isNotEmpty) {
      _updateTask(
        candidate.workOrderId,
        (t) => t.copyWith(status: ArchiveTaskStatus.confirming),
      );
      try {
        await _repository.confirm(candidate.workOrderId, verifiedIds);
      } on ApiException catch (e) {
        _updateTask(
          candidate.workOrderId,
          (t) => t.copyWith(
            status: ArchiveTaskStatus.error,
            errorMessage: e.detail ?? e.message,
          ),
        );
        return;
      }
    }

    final failedCount = items.length - verifiedIds.length;
    final summary = failedCount == 0
        ? '${items.length} medyadan tümü doğrulandı ve sunucudan silindi.'
        : '${items.length} medyadan ${verifiedIds.length}\'i doğrulandı ve '
            'sunucudan silindi; $failedCount\'i doğrulanamadı, aday '
            'listesinde kalıyor.';

    _updateTask(
      candidate.workOrderId,
      (t) => t.copyWith(status: ArchiveTaskStatus.done, resultSummary: summary),
    );
  }

  String _buildDestinationPath(
    String targetRoot,
    ArchiveCandidateDto candidate,
    ArchiveMediaItemDto item,
  ) {
    final year = candidate.closedAt.year.toString();
    final stage = item.stage.toLowerCase();
    return p.join(targetRoot, year, candidate.orderNumber, stage, item.fileName);
  }

  Future<void> _deleteIfExists(String path) async {
    final file = File(path);
    if (await file.exists()) {
      try {
        await file.delete();
      } catch (_) {
        // Best-effort cleanup; a leftover unverified file is not fatal.
      }
    }
  }

  void _updateTask(int workOrderId, ArchiveTask Function(ArchiveTask) update) {
    final tasks = state.tasks
        .map((t) => t.workOrderId == workOrderId ? update(t) : t)
        .toList();
    emit(state.copyWith(tasks: tasks));
  }
}
