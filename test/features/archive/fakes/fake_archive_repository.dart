import 'dart:io';

import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/archive/data/archive_repository.dart';
import 'package:leather_care_admin/features/archive/data/dto/archive_candidate_dto.dart';
import 'package:leather_care_admin/features/archive/data/dto/archive_export_response_dto.dart';

class FakeArchiveRepository implements IArchiveRepository {
  List<ArchiveCandidateDto> candidatesToReturn = const [];
  ApiException? candidatesException;

  ArchiveExportResponseDto? exportResultToReturn;
  ApiException? exportException;

  ApiException? confirmException;
  int? lastConfirmedWorkOrderId;
  List<int>? lastConfirmedIds;

  Map<String, List<int>> bytesByUrl = {};
  Map<String, String?> etagByUrl = {};
  ApiException? downloadException;
  final List<String> downloadedUrls = [];

  @override
  Future<List<ArchiveCandidateDto>> fetchCandidates({
    int olderThanDays = 90,
  }) async {
    if (candidatesException != null) throw candidatesException!;
    return candidatesToReturn;
  }

  @override
  Future<ArchiveExportResponseDto> export(int workOrderId) async {
    if (exportException != null) throw exportException!;
    return exportResultToReturn!;
  }

  @override
  Future<void> confirm(int workOrderId, List<int> verifiedMediaIds) async {
    lastConfirmedWorkOrderId = workOrderId;
    lastConfirmedIds = verifiedMediaIds;
    if (confirmException != null) throw confirmException!;
  }

  @override
  Future<String?> downloadToFile(String url, String destinationPath) async {
    downloadedUrls.add(url);
    if (downloadException != null) throw downloadException!;
    final bytes = bytesByUrl[url] ?? const <int>[1, 2, 3];
    await File(destinationPath).writeAsBytes(bytes);
    return etagByUrl[url];
  }
}
