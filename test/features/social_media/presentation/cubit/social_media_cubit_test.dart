import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/network/paged_response.dart';
import 'package:leather_care_admin/features/social_media/data/dto/social_media_item_dto.dart';
import 'package:leather_care_admin/features/social_media/presentation/cubit/social_media_cubit.dart';
import 'package:leather_care_admin/features/social_media/presentation/cubit/social_media_state.dart';

import '../../fakes/fake_social_media_repository.dart';

void main() {
  late FakeSocialMediaRepository repository;

  setUp(() {
    repository = FakeSocialMediaRepository();
  });

  SocialMediaItemDto buildItem({required int workOrderId}) {
    return SocialMediaItemDto(
      workOrderId: workOrderId,
      orderNumber: 'WO-2026-0000$workOrderId',
      status: 'READY',
      categoryPath: 'Kadın > Ayakkabı > Sneakers',
      brand: 'Nike',
      socialMediaConsentAt: DateTime(2026, 1, 1),
      beforeMedia: const [],
      afterMedia: const [],
    );
  }

  test('load populates items on success', () async {
    repository.pageToReturn = PagedResponse(
      items: [buildItem(workOrderId: 1), buildItem(workOrderId: 2)],
      page: 1,
      pageSize: 20,
      totalCount: 2,
    );
    final cubit = SocialMediaCubit(repository);

    await cubit.load();

    expect(cubit.state.status, SocialMediaStatus.loaded);
    expect(cubit.state.items, hasLength(2));
    expect(cubit.state.hasNextPage, isFalse);
  });

  test('load emits error state with the ApiException detail', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Unauthorized',
      detail: 'Oturum süresi doldu.',
      statusCode: 401,
    );
    final cubit = SocialMediaCubit(repository);

    await cubit.load();

    expect(cubit.state.status, SocialMediaStatus.error);
    expect(cubit.state.errorMessage, 'Oturum süresi doldu.');
  });

  test('load(page: 2) requests the given page and updates hasPreviousPage', () async {
    repository.pageToReturn = PagedResponse(
      items: [buildItem(workOrderId: 3)],
      page: 2,
      pageSize: 1,
      totalCount: 3,
    );
    final cubit = SocialMediaCubit(repository);

    await cubit.load(page: 2);

    expect(cubit.state.page, 2);
    expect(cubit.state.hasPreviousPage, isTrue);
    expect(cubit.state.hasNextPage, isTrue);
  });

  test('downloadMedia forwards to the repository and returns null on success', () async {
    final cubit = SocialMediaCubit(repository);

    final error = await cubit.downloadMedia(
      'https://minio.local/view/1',
      '/tmp/photo.jpg',
    );

    expect(error, isNull);
    expect(repository.lastDownloadedUrl, 'https://minio.local/view/1');
    expect(repository.lastDestinationPath, '/tmp/photo.jpg');
  });

  test('downloadMedia returns a Turkish error message on failure', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Forbidden',
      statusCode: 403,
    );
    final cubit = SocialMediaCubit(repository);

    final error = await cubit.downloadMedia(
      'https://minio.local/view/1',
      '/tmp/photo.jpg',
    );

    expect(error, contains('süresi dolmuş olabilir'));
  });
}
