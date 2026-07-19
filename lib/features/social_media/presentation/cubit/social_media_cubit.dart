import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/social_media_repository.dart';
import 'social_media_state.dart';

class SocialMediaCubit extends Cubit<SocialMediaState> {
  SocialMediaCubit(this._repository) : super(const SocialMediaState());

  final ISocialMediaRepository _repository;

  Future<void> load({int page = 1}) async {
    emit(
      SocialMediaState(
        status: SocialMediaStatus.loading,
        page: page,
        pageSize: state.pageSize,
        items: state.items,
        totalCount: state.totalCount,
      ),
    );

    try {
      final result = await _repository.fetchItems(
        page: page,
        pageSize: state.pageSize,
      );
      emit(
        SocialMediaState(
          status: SocialMediaStatus.loaded,
          page: result.page,
          pageSize: result.pageSize,
          items: result.items,
          totalCount: result.totalCount,
        ),
      );
    } on ApiException catch (e) {
      emit(
        SocialMediaState(
          status: SocialMediaStatus.error,
          page: page,
          pageSize: state.pageSize,
          errorMessage: e.detail ?? e.message,
        ),
      );
    }
  }

  Future<String?> downloadMedia(String viewUrl, String destinationPath) async {
    try {
      await _repository.downloadMedia(viewUrl, destinationPath);
      return null;
    } on ApiException {
      return 'İndirme başarısız oldu. Bağlantının süresi dolmuş olabilir, '
          'listeyi yenileyip tekrar deneyin.';
    }
  }
}
