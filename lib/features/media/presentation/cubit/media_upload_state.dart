import 'upload_task.dart';

class MediaUploadState {
  const MediaUploadState({this.tasks = const <UploadTask>[]});

  final List<UploadTask> tasks;

  int get completedCount =>
      tasks.where((task) => task.status == UploadTaskStatus.done).length;
}
