class PagedResponse<T> {
  const PagedResponse({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  factory PagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) itemFromJson,
  ) {
    final rawItems = json['items'] as List<dynamic>? ?? const [];

    return PagedResponse<T>(
      items: rawItems
          .map((item) => itemFromJson(item as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      totalCount: json['totalCount'] as int,
    );
  }

  final List<T> items;
  final int page;
  final int pageSize;
  final int totalCount;

  bool get hasNextPage => page * pageSize < totalCount;
}
