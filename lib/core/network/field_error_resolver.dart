/// `ApiException.fieldErrors` anahtarları backend'den iki biçimde gelebilir:
/// model-binding hatalarında `$.alanAdi`, FluentValidation hatalarında
/// `AlanAdi` (PascalCase). Bu sınıf her iki biçimi de aynı camelCase alana
/// çözer, böylece formlar tek bir sözleşmeye göre `errorText` bağlayabilir.
class FieldErrorResolver {
  FieldErrorResolver(this._fieldErrors);

  final Map<String, List<String>> _fieldErrors;

  String? errorFor(String camelCaseField) {
    final candidates = {
      camelCaseField,
      '\$.$camelCaseField',
      camelCaseField[0].toUpperCase() + camelCaseField.substring(1),
    };
    for (final key in candidates) {
      final messages = _fieldErrors[key];
      if (messages != null && messages.isNotEmpty) {
        return messages.join('\n');
      }
    }
    return null;
  }

  bool get hasAny => _fieldErrors.isNotEmpty;
}
