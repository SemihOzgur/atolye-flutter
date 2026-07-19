import '../../data/dto/social_media_item_dto.dart';

enum SocialMediaStatus { loading, loaded, error }

class SocialMediaState {
  const SocialMediaState({
    this.status = SocialMediaStatus.loading,
    this.page = 1,
    this.pageSize = 20,
    this.items = const <SocialMediaItemDto>[],
    this.totalCount = 0,
    this.errorMessage,
  });

  final SocialMediaStatus status;
  final int page;
  final int pageSize;
  final List<SocialMediaItemDto> items;
  final int totalCount;
  final String? errorMessage;

  bool get hasNextPage => page * pageSize < totalCount;

  bool get hasPreviousPage => page > 1;
}
