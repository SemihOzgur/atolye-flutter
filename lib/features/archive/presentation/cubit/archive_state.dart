import '../../data/dto/archive_candidate_dto.dart';
import 'archive_task.dart';

enum ArchiveListStatus { idle, loading, loaded, error }

class ArchiveState {
  const ArchiveState({
    this.listStatus = ArchiveListStatus.idle,
    this.olderThanDays = 90,
    this.candidates = const <ArchiveCandidateDto>[],
    this.selectedWorkOrderIds = const <int>{},
    this.targetRootPath,
    this.isArchiving = false,
    this.tasks = const <ArchiveTask>[],
    this.errorMessage,
  });

  final ArchiveListStatus listStatus;
  final int olderThanDays;
  final List<ArchiveCandidateDto> candidates;
  final Set<int> selectedWorkOrderIds;
  final String? targetRootPath;
  final bool isArchiving;
  final List<ArchiveTask> tasks;
  final String? errorMessage;

  bool get canArchive =>
      selectedWorkOrderIds.isNotEmpty && targetRootPath != null && !isArchiving;

  ArchiveState copyWith({
    ArchiveListStatus? listStatus,
    int? olderThanDays,
    List<ArchiveCandidateDto>? candidates,
    Set<int>? selectedWorkOrderIds,
    String? targetRootPath,
    bool? isArchiving,
    List<ArchiveTask>? tasks,
    String? errorMessage,
  }) {
    return ArchiveState(
      listStatus: listStatus ?? this.listStatus,
      olderThanDays: olderThanDays ?? this.olderThanDays,
      candidates: candidates ?? this.candidates,
      selectedWorkOrderIds: selectedWorkOrderIds ?? this.selectedWorkOrderIds,
      targetRootPath: targetRootPath ?? this.targetRootPath,
      isArchiving: isArchiving ?? this.isArchiving,
      tasks: tasks ?? this.tasks,
      errorMessage: errorMessage,
    );
  }
}
