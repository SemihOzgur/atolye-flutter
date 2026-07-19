import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/archive/data/archive_integrity_checker.dart';
import 'package:leather_care_admin/features/archive/data/dto/archive_candidate_dto.dart';
import 'package:leather_care_admin/features/archive/data/dto/archive_export_response_dto.dart';
import 'package:leather_care_admin/features/archive/data/dto/archive_media_item_dto.dart';
import 'package:leather_care_admin/features/archive/presentation/cubit/archive_cubit.dart';
import 'package:leather_care_admin/features/archive/presentation/cubit/archive_state.dart';
import 'package:leather_care_admin/features/archive/presentation/cubit/archive_task.dart';

import '../../fakes/fake_archive_repository.dart';

// MD5("hello") — a fixed, known-good hash used to simulate a verified download.
const _helloMd5 = '5d41402abc4b2a76b9719d911017c592';

void main() {
  late FakeArchiveRepository repository;
  late Directory tempDir;

  setUp(() async {
    repository = FakeArchiveRepository();
    tempDir = await Directory.systemTemp.createTemp('archive_cubit_test');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  ArchiveCandidateDto buildCandidate({
    required int workOrderId,
    int mediaCount = 1,
  }) {
    return ArchiveCandidateDto(
      workOrderId: workOrderId,
      orderNumber: 'WO-2026-00000$workOrderId',
      status: 'DELIVERED',
      closedAt: DateTime(2026, 1, 1),
      mediaCount: mediaCount,
      totalSizeBytes: 1024,
      hasSocialMediaConsent: false,
    );
  }

  test('loadCandidates populates the list on success', () async {
    repository.candidatesToReturn = [buildCandidate(workOrderId: 1)];
    final cubit = ArchiveCubit(repository, ArchiveIntegrityChecker());

    await cubit.loadCandidates();

    expect(cubit.state.listStatus, ArchiveListStatus.loaded);
    expect(cubit.state.candidates, hasLength(1));
  });

  test('loadCandidates emits an error state with the ApiException detail', () async {
    repository.candidatesException = ApiException(
      message: 'Unauthorized',
      detail: 'Oturum süresi doldu.',
      statusCode: 401,
    );
    final cubit = ArchiveCubit(repository, ArchiveIntegrityChecker());

    await cubit.loadCandidates();

    expect(cubit.state.listStatus, ArchiveListStatus.error);
    expect(cubit.state.errorMessage, 'Oturum süresi doldu.');
  });

  test('toggleSelection adds then removes a work order id', () {
    final cubit = ArchiveCubit(repository, ArchiveIntegrityChecker());

    cubit.toggleSelection(1);
    expect(cubit.state.selectedWorkOrderIds, {1});

    cubit.toggleSelection(1);
    expect(cubit.state.selectedWorkOrderIds, isEmpty);
  });

  test('canArchive requires a selection, a target folder, and not already archiving', () {
    final cubit = ArchiveCubit(repository, ArchiveIntegrityChecker());
    expect(cubit.state.canArchive, isFalse);

    cubit.toggleSelection(1);
    expect(cubit.state.canArchive, isFalse);

    cubit.setTargetRoot('/tmp/archive-root');
    expect(cubit.state.canArchive, isTrue);
  });

  test('archiveSelected does nothing when canArchive is false', () async {
    final cubit = ArchiveCubit(repository, ArchiveIntegrityChecker());

    await cubit.archiveSelected();

    expect(cubit.state.tasks, isEmpty);
    expect(repository.downloadedUrls, isEmpty);
  });

  test(
    'archiveSelected verifies every item, confirms them all, and reloads candidates',
    () async {
      repository.candidatesToReturn = [
        buildCandidate(workOrderId: 7, mediaCount: 2),
      ];
      repository.exportResultToReturn = ArchiveExportResponseDto(
        workOrderId: 7,
        items: const [
          ArchiveMediaItemDto(
            mediaId: 1,
            stage: 'BEFORE',
            mediaType: 'PHOTO',
            fileName: 'before.jpg',
            sizeBytes: 5,
            downloadUrl: 'https://minio.local/1',
          ),
          ArchiveMediaItemDto(
            mediaId: 2,
            stage: 'AFTER',
            mediaType: 'PHOTO',
            fileName: 'after.jpg',
            sizeBytes: 5,
            downloadUrl: 'https://minio.local/2',
          ),
        ],
      );
      final helloBytes = utf8.encode('hello');
      repository.bytesByUrl['https://minio.local/1'] = helloBytes;
      repository.bytesByUrl['https://minio.local/2'] = helloBytes;
      repository.etagByUrl['https://minio.local/1'] = _helloMd5;
      repository.etagByUrl['https://minio.local/2'] = _helloMd5;

      final cubit = ArchiveCubit(repository, ArchiveIntegrityChecker());
      await cubit.loadCandidates();
      cubit.toggleSelection(7);
      cubit.setTargetRoot(tempDir.path);

      // Candidate list is fetched again by archiveSelected's trailing reload.
      repository.candidatesToReturn = const [];

      await cubit.archiveSelected();

      final task = cubit.state.tasks.single;
      expect(task.status, ArchiveTaskStatus.done);
      expect(task.verifiedCount, 2);
      expect(task.failedCount, 0);
      expect(task.resultSummary, contains('tümü doğrulandı'));

      expect(repository.lastConfirmedWorkOrderId, 7);
      expect(repository.lastConfirmedIds, [1, 2]);

      expect(
        File('${tempDir.path}/2026/WO-2026-000007/before/before.jpg')
            .existsSync(),
        isTrue,
      );
      expect(
        File('${tempDir.path}/2026/WO-2026-000007/after/after.jpg')
            .existsSync(),
        isTrue,
      );

      // Trailing reload cleared the selection and refreshed the list.
      expect(cubit.state.selectedWorkOrderIds, isEmpty);
      expect(cubit.state.candidates, isEmpty);
      expect(cubit.state.isArchiving, isFalse);
    },
  );

  test(
    'archiveSelected keeps a mismatched file out of confirm and deletes it',
    () async {
      repository.candidatesToReturn = [
        buildCandidate(workOrderId: 7, mediaCount: 2),
      ];
      repository.exportResultToReturn = ArchiveExportResponseDto(
        workOrderId: 7,
        items: const [
          ArchiveMediaItemDto(
            mediaId: 1,
            stage: 'BEFORE',
            mediaType: 'PHOTO',
            fileName: 'good.jpg',
            sizeBytes: 5,
            downloadUrl: 'https://minio.local/good',
          ),
          ArchiveMediaItemDto(
            mediaId: 2,
            stage: 'BEFORE',
            mediaType: 'PHOTO',
            fileName: 'bad.jpg',
            sizeBytes: 5,
            downloadUrl: 'https://minio.local/bad',
          ),
        ],
      );
      repository.bytesByUrl['https://minio.local/good'] = utf8.encode('hello');
      repository.etagByUrl['https://minio.local/good'] = _helloMd5;
      repository.bytesByUrl['https://minio.local/bad'] = utf8.encode('world');
      repository.etagByUrl['https://minio.local/bad'] = _helloMd5; // mismatch

      final cubit = ArchiveCubit(repository, ArchiveIntegrityChecker());
      await cubit.loadCandidates();
      cubit.toggleSelection(7);
      cubit.setTargetRoot(tempDir.path);

      await cubit.archiveSelected();

      final task = cubit.state.tasks.single;
      expect(task.verifiedCount, 1);
      expect(task.failedCount, 1);
      expect(task.resultSummary, contains("1'i doğrulanamadı"));

      expect(repository.lastConfirmedIds, [1]);
      expect(
        File('${tempDir.path}/2026/WO-2026-000007/before/bad.jpg')
            .existsSync(),
        isFalse,
      );
      expect(
        File('${tempDir.path}/2026/WO-2026-000007/before/good.jpg')
            .existsSync(),
        isTrue,
      );
    },
  );

  test('archiveSelected does not call confirm when nothing verified', () async {
    repository.candidatesToReturn = [
      buildCandidate(workOrderId: 7, mediaCount: 1),
    ];
    repository.exportResultToReturn = const ArchiveExportResponseDto(
      workOrderId: 7,
      items: [
        ArchiveMediaItemDto(
          mediaId: 1,
          stage: 'BEFORE',
          mediaType: 'PHOTO',
          fileName: 'bad.jpg',
          sizeBytes: 5,
          downloadUrl: 'https://minio.local/bad',
        ),
      ],
    );
    repository.bytesByUrl['https://minio.local/bad'] = utf8.encode('world');
    repository.etagByUrl['https://minio.local/bad'] = _helloMd5;

    final cubit = ArchiveCubit(repository, ArchiveIntegrityChecker());
    await cubit.loadCandidates();
    cubit.toggleSelection(7);
    cubit.setTargetRoot(tempDir.path);

    await cubit.archiveSelected();

    expect(repository.lastConfirmedWorkOrderId, isNull);
    expect(cubit.state.tasks.single.failedCount, 1);
  });

  test('archiveSelected marks the task as error when export fails', () async {
    repository.candidatesToReturn = [
      buildCandidate(workOrderId: 7, mediaCount: 1),
    ];
    repository.exportException = ApiException(
      message: 'Conflict',
      detail: 'İş emri açık.',
      statusCode: 409,
    );

    final cubit = ArchiveCubit(repository, ArchiveIntegrityChecker());
    await cubit.loadCandidates();
    cubit.toggleSelection(7);
    cubit.setTargetRoot(tempDir.path);

    await cubit.archiveSelected();

    final task = cubit.state.tasks.single;
    expect(task.status, ArchiveTaskStatus.error);
    expect(task.errorMessage, 'İş emri açık.');
    expect(repository.downloadedUrls, isEmpty);
  });

  test('archiveSelected reports no media found when export returns an empty list', () async {
    repository.candidatesToReturn = [
      buildCandidate(workOrderId: 7, mediaCount: 0),
    ];
    repository.exportResultToReturn = const ArchiveExportResponseDto(
      workOrderId: 7,
      items: [],
    );

    final cubit = ArchiveCubit(repository, ArchiveIntegrityChecker());
    await cubit.loadCandidates();
    cubit.toggleSelection(7);
    cubit.setTargetRoot(tempDir.path);

    await cubit.archiveSelected();

    final task = cubit.state.tasks.single;
    expect(task.status, ArchiveTaskStatus.done);
    expect(task.resultSummary, contains('bulunamadı'));
    expect(repository.lastConfirmedWorkOrderId, isNull);
  });
}
