import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/network/paged_response.dart';
import 'package:leather_care_admin/features/social_media/data/dto/social_media_item_dto.dart';
import 'package:leather_care_admin/features/social_media/data/social_media_repository.dart';

class FakeSocialMediaRepository implements ISocialMediaRepository {
  PagedResponse<SocialMediaItemDto>? pageToReturn;
  ApiException? exceptionToThrow;

  String? lastDownloadedUrl;
  String? lastDestinationPath;

  @override
  Future<PagedResponse<SocialMediaItemDto>> fetchItems({
    int page = 1,
    int pageSize = 20,
  }) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return pageToReturn ??
        PagedResponse<SocialMediaItemDto>(
          items: const [],
          page: page,
          pageSize: pageSize,
          totalCount: 0,
        );
  }

  @override
  Future<void> downloadMedia(String viewUrl, String destinationPath) async {
    lastDownloadedUrl = viewUrl;
    lastDestinationPath = destinationPath;
    if (exceptionToThrow != null) throw exceptionToThrow!;
  }
}
