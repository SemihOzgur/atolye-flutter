enum AuthFormStatus { idle, submitting, failure, rateLimited }

class AuthState {
  const AuthState({
    this.status = AuthFormStatus.idle,
    this.errorMessage,
    this.retryAfterSeconds,
  });

  final AuthFormStatus status;
  final String? errorMessage;
  final int? retryAfterSeconds;
}
