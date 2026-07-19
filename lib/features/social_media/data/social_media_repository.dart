import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/paged_response.dart';
import 'dto/social_media_item_dto.dart';

abstract class ISocialMediaRepository {
  Future<PagedResponse<SocialMediaItemDto>> fetchItems({
    int page = 1,
    int pageSize = 20,
  });

  Future<void> downloadMedia(String viewUrl, String destinationPath);
}

class SocialMediaRepository implements ISocialMediaRepository {
  SocialMediaRepository(this._dio, {Dio? downloadClient})
      : _downloadClient = downloadClient ?? Dio();

  final Dio _dio;
  final Dio _downloadClient;

  @override
  Future<PagedResponse<SocialMediaItemDto>> fetchItems({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.socialMediaItems.path,
        queryParameters: {'page': page, 'pageSize': pageSize},
      );

      return PagedResponse.fromJson(
        response.data!,
        SocialMediaItemDto.fromJson,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<void> downloadMedia(String viewUrl, String destinationPath) async {
    try {
      await _downloadClient.download(viewUrl, destinationPath);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
