import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/services/storage_service.dart';
import 'dto/login_request_dto.dart';
import 'dto/login_response_dto.dart';

abstract class IAuthRepository {
  Future<void> login({required String email, required String password});
}

class AuthRepository implements IAuthRepository {
  AuthRepository(this._dio, this._storageService);

  final Dio _dio;
  final ISecureStorageService _storageService;

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.login.path,
        data: LoginRequestDto(email: email, password: password).toJson(),
      );

      final dto = LoginResponseDto.fromJson(response.data!);
      await _storageService.write(StorageKeys.authToken, dto.token);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
