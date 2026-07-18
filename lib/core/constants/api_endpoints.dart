enum HttpMethod { get, post, put, delete, patch }

class ApiRoute {
  final String path;
  final HttpMethod method;

  const ApiRoute(this.path, this.method);
}

class ApiEndpoints {
  ApiEndpoints._();

    static const String baseUrl = String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://domain.com',
    );

  static const ApiRoute login = ApiRoute('/api/auth/login', HttpMethod.post);

  static const ApiRoute createCustomer =
      ApiRoute('/api/customers', HttpMethod.post);
  static const ApiRoute searchCustomers =
      ApiRoute('/api/customers', HttpMethod.get);
  static ApiRoute customerDetail(int customerId) =>
      ApiRoute('/api/customers/$customerId', HttpMethod.get);
  static ApiRoute updateCustomer(int customerId) =>
      ApiRoute('/api/customers/$customerId', HttpMethod.put);
  static ApiRoute resendIysCode(int customerId) => ApiRoute(
        '/api/customers/$customerId/iys/resend-code',
        HttpMethod.post,
      );
  static ApiRoute confirmIysCode(int customerId) => ApiRoute(
        '/api/customers/$customerId/iys/confirm',
        HttpMethod.post,
      );

  static const ApiRoute categoriesTree =
      ApiRoute('/api/categories/tree', HttpMethod.get);
  static const ApiRoute createCategory =
      ApiRoute('/api/categories', HttpMethod.post);
  static ApiRoute updateCategory(int categoryId) =>
      ApiRoute('/api/categories/$categoryId', HttpMethod.put);

  static const ApiRoute serviceTypes =
      ApiRoute('/api/service-types', HttpMethod.get);
  static const ApiRoute createServiceType =
      ApiRoute('/api/service-types', HttpMethod.post);
  static ApiRoute updateServiceType(int serviceTypeId) =>
      ApiRoute('/api/service-types/$serviceTypeId', HttpMethod.put);

  static const ApiRoute servicePrices =
      ApiRoute('/api/service-prices', HttpMethod.get);
  static const ApiRoute servicePricesBulk =
      ApiRoute('/api/service-prices/bulk', HttpMethod.put);
  static ApiRoute categoryServices(int categoryId) =>
      ApiRoute('/api/categories/$categoryId/services', HttpMethod.get);

  static const ApiRoute consumableGroups =
      ApiRoute('/api/consumable-groups', HttpMethod.get);
  static const ApiRoute createConsumableGroup =
      ApiRoute('/api/consumable-groups', HttpMethod.post);
  static ApiRoute updateConsumableGroup(int groupId) =>
      ApiRoute('/api/consumable-groups/$groupId', HttpMethod.put);

  static const ApiRoute consumableProducts =
      ApiRoute('/api/consumable-products', HttpMethod.get);
  static const ApiRoute createConsumableProduct =
      ApiRoute('/api/consumable-products', HttpMethod.post);
  static ApiRoute updateConsumableProduct(int productId) =>
      ApiRoute('/api/consumable-products/$productId', HttpMethod.put);

  static const ApiRoute createWorkOrder =
      ApiRoute('/api/work-orders', HttpMethod.post);
  static const ApiRoute searchWorkOrders =
      ApiRoute('/api/work-orders', HttpMethod.get);
  static ApiRoute workOrderDetail(int workOrderId) =>
      ApiRoute('/api/work-orders/$workOrderId', HttpMethod.get);
  static ApiRoute updateWorkOrder(int workOrderId) =>
      ApiRoute('/api/work-orders/$workOrderId', HttpMethod.put);
  static ApiRoute updateWorkOrderStatus(int workOrderId) =>
      ApiRoute('/api/work-orders/$workOrderId/status', HttpMethod.patch);
  static ApiRoute deliverWorkOrder(int workOrderId) =>
      ApiRoute('/api/work-orders/$workOrderId/deliver', HttpMethod.post);
  static ApiRoute resendSms(int workOrderId) =>
      ApiRoute('/api/work-orders/$workOrderId/sms/resend', HttpMethod.post);

  static ApiRoute requestMediaUpload(int workOrderId) => ApiRoute(
        '/api/work-orders/$workOrderId/media/request-upload',
        HttpMethod.post,
      );
  static ApiRoute confirmMediaUpload(int workOrderId) => ApiRoute(
        '/api/work-orders/$workOrderId/media/confirm',
        HttpMethod.post,
      );
  static ApiRoute getMediaList(int workOrderId) => ApiRoute(
        '/api/work-orders/$workOrderId/media',
        HttpMethod.get,
      );
  static ApiRoute deleteMedia(int mediaId) =>
      ApiRoute('/api/media/$mediaId', HttpMethod.delete);

  static ApiRoute publicTracking(String token) =>
      ApiRoute('/api/public/tracking/$token', HttpMethod.get);
  static ApiRoute publicSocialMediaConsent(String token) => ApiRoute(
        '/api/public/tracking/$token/social-media-consent',
        HttpMethod.put,
      );

  static const ApiRoute dashboardSummary =
      ApiRoute('/api/dashboard/summary', HttpMethod.get);
  static const ApiRoute socialMediaItems =
      ApiRoute('/api/social-media/items', HttpMethod.get);

  static const ApiRoute archiveCandidates =
      ApiRoute('/api/archive/candidates', HttpMethod.get);
  static ApiRoute archiveExport(int workOrderId) =>
      ApiRoute('/api/archive/$workOrderId/export', HttpMethod.post);
  static ApiRoute archiveConfirm(int workOrderId) =>
      ApiRoute('/api/archive/$workOrderId/confirm', HttpMethod.post);

  static const ApiRoute downloadLatestBackup =
      ApiRoute('/api/admin/backups/latest', HttpMethod.get);
}
