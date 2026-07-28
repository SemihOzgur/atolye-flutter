class PrintResult {
  const PrintResult._({required this.success, this.failureReason});

  factory PrintResult.success() => const PrintResult._(success: true);

  factory PrintResult.failure(String reason) =>
      PrintResult._(success: false, failureReason: reason);

  final bool success;
  final String? failureReason;
}
