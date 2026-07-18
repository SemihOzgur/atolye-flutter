import '../../data/dto/customer_dto.dart';

enum CustomerFormStatus { idle, submitting, failure }

class CustomerFormSuccess {
  const CustomerFormSuccess({
    required this.customer,
    required this.isDuplicate,
    required this.requiresIysVerification,
    this.iysCodeExpiresAt,
  });

  final CustomerDto customer;
  final bool isDuplicate;
  final bool requiresIysVerification;
  final DateTime? iysCodeExpiresAt;
}

class CustomerFormState {
  const CustomerFormState({
    this.status = CustomerFormStatus.idle,
    this.errorMessage,
    this.fieldErrors = const <String, List<String>>{},
    this.success,
  });

  final CustomerFormStatus status;
  final String? errorMessage;
  final Map<String, List<String>> fieldErrors;
  final CustomerFormSuccess? success;
}
