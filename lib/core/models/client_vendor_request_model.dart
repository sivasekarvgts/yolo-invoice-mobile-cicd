class ClientVendorRequestModel {
  ClientVendorRequestModel({
    this.id,
    this.page,
    this.search,
    this.addClient = false,
    this.addVendor = false,
    this.startDate,
    this.endDate,
  });

  final int? id;
  final int? page;
  final String? search;
  final String? startDate;
  final String? endDate;
  final bool addClient;
  final bool addVendor;

  /// Returns a query parameter string for API requests
  /// Only includes parameters that are not null
  String get filters {
    final Map<String, String> params = {};

    // Add page_size as a default or use page if provided

    if (page != null) {
      params['page_size'] = '20';
      params['page'] = page.toString();
    }

    if (search != null || search?.isNotEmpty == true) {
      params['search'] = search!;
    }

    if (startDate != null) {
      params['start_date'] = startDate!;
    }

    if (endDate != null) {
      params['end_date'] = endDate!;
    }

    // Add vendor_id or customer_id based on addCustomer flag
    if (addClient && id != null) {
      params['client_id'] = id.toString();
    }

    if (addVendor && id != null) {
      params['vendor_id'] = id.toString();
    }

    // Build the query string
    String queryString =
        params.entries.map((entry) => '${entry.key}=${entry.value}').join('&');

    queryString = queryString.isNotEmpty ? '?$queryString' : '';

    if (!addClient && !addVendor && id != null)
      queryString = "${id}/$queryString";

    return queryString;
  }
}
