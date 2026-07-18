import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('parses ProblemDetails and validation errors', () {
    final exception = ApiException.fromDioException(
      DioException(
        requestOptions: RequestOptions(path: '/api/auth/login'),
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/api/auth/login'),
          statusCode: 400,
          data: <String, dynamic>{
            'title': 'Validation failed',
            'detail': 'One or more validation errors occurred.',
            'errorCode': 'VALIDATION_ERROR',
            'errors': <String, dynamic>{
              'email': <String>['Email is required.'],
              'password': <String>['Password is required.'],
            },
          },
        ),
        type: DioExceptionType.badResponse,
      ),
    );

    expect(exception.statusCode, 400);
    expect(exception.title, 'Validation failed');
    expect(exception.detail, 'One or more validation errors occurred.');
    expect(exception.errorCode, 'VALIDATION_ERROR');
    expect(exception.fieldErrors['email'], <String>['Email is required.']);
    expect(exception.fieldErrors['password'], <String>['Password is required.']);
  });
}