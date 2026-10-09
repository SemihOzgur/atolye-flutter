import 'upload_task.dart';

class MediaUploadState {
  const MediaUploadState({this.tasks = const <UploadTask>[]});

  final List<UploadTask> tasks;

  int get completedCount =>
      tasks.where((task) => task.status == UploadTaskStatus.done).length;

  /// İş emrinde dolu medya yeri: galerideki kayıtlar + henüz galeriye
  /// yansımamış görevler. Biten görev, galeri yenilenip aynı kayıt geldiğinde
  /// artık sayılmaz — eskiden hem galeride hem "Tamam" satırında sayılıyor,
  /// 11 yüklemede sayaç 31/20 gösterip seçimi kilitliyordu. Hatalı görevler
  /// sunucuda yer tutmaz (PENDING satırı 24 saatte temizlenir).
  int occupiedSlots(Set<int> galleryMediaIds) {
    final notYetInGallery = tasks.where((task) {
      switch (task.status) {
        case UploadTaskStatus.error:
          return false;
        case UploadTaskStatus.done:
          return task.mediaFileId == null ||
              !galleryMediaIds.contains(task.mediaFileId);
        case UploadTaskStatus.queued:
        case UploadTaskStatus.converting:
        case UploadTaskStatus.uploading:
        case UploadTaskStatus.confirming:
          return true;
      }
    }).length;
    return galleryMediaIds.length + notYetInGallery;
  }
}
