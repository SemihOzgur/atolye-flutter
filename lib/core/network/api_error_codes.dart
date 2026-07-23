abstract class ApiErrorCodes {
  static const String duplicatePhone = 'DUPLICATE_PHONE';
  static const String codeExpired = 'CODE_EXPIRED';
  static const String codeLocked = 'CODE_LOCKED';
  static const String noActiveCode = 'NO_ACTIVE_CODE';
  static const String iysPendingConfirmation = 'IYS_PENDING_CONFIRMATION';
  static const String alreadyConsented = 'ALREADY_CONSENTED';
  static const String orderClosed = 'ORDER_CLOSED';
  static const String invalidStatusTransition = 'INVALID_STATUS_TRANSITION';
  static const String serviceCategoryMismatch = 'SERVICE_CATEGORY_MISMATCH';
  static const String invalidCatalogItem = 'INVALID_CATALOG_ITEM';
  static const String invalidCategoryLevel = 'INVALID_CATEGORY_LEVEL';

  // Katalog silme (§11.11)
  static const String categoryNotFound = 'CATEGORY_NOT_FOUND';
  static const String categoryHasChildren = 'CATEGORY_HAS_CHILDREN';
  static const String categoryInUse = 'CATEGORY_IN_USE';
  static const String serviceTypeNotFound = 'SERVICE_TYPE_NOT_FOUND';
  static const String serviceTypeInUse = 'SERVICE_TYPE_IN_USE';
  static const String groupNotFound = 'GROUP_NOT_FOUND';
  static const String consumableGroupInUse = 'CONSUMABLE_GROUP_IN_USE';
  static const String productNotFound = 'PRODUCT_NOT_FOUND';
  static const String consumableProductInUse = 'CONSUMABLE_PRODUCT_IN_USE';
}
