/// Backend `DateOnly` alanları için JSON dönüşümü: gönderirken "yyyy-MM-dd",
/// okurken DateTime. `toIso8601String()` kullanılmaz — o tam zaman damgası
/// üretir ve backend'in `DateOnly?` model binding'i bunu kabul etmez.
String? dateOnlyToJson(DateTime? date) => date == null
    ? null
    : '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';

DateTime? dateOnlyFromJson(String? value) =>
    value == null ? null : DateTime.parse(value);
