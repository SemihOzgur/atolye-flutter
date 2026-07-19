import '../../data/dto/category_tree_dto.dart';

enum CategoryTreeStatus { loading, loaded, error }

class CategoryState {
  const CategoryState({
    this.status = CategoryTreeStatus.loading,
    this.tree = const <CategoryTreeDto>[],
    this.includeInactive = false,
    this.errorMessage,
  });

  final CategoryTreeStatus status;
  final List<CategoryTreeDto> tree;
  final bool includeInactive;
  final String? errorMessage;
}
