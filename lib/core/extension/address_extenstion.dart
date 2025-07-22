import '../models/address_detail.dart';

extension AddressListExtension on List<AddressDetail>? {
  // addressType = 1 -> billing
  // addressType = 2 -> shipping
  AddressDetail? getBillAddress() {
    if (this == null || this!.isEmpty == true) return null;
    final data = this?.where((t) => t.addressType == 1).toList();
    if (data?.isEmpty == true) return null;
    return data?.first;
  }

  AddressDetail? getShippingAddress() {
    if (this == null || this!.isEmpty == true) return null;
    final data = this?.where((t) => t.addressType == 2).toList();
    if (data?.isEmpty == true) return null;
    return data?.first;
  }

  String? toCityAddressOne({bool isShipping = false}) {
    AddressDetail? address = getBillAddress();
    final formattedAddress =
        '${address?.city ?? ''}${address?.address2?.isNotEmpty == true ? ' - ${address?.address2}' : ''}';
    return formattedAddress;
  }

  String? inFullAddress({bool isShipping = false}) {
    AddressDetail? address = getBillAddress();
    final formattedAddress =
        '${address?.address1 == null ? "" : "${address?.address1}, "}${address?.address2?.isNotEmpty == true ? '${address?.address2}, ' : ''}${address?.city}${address?.stateName == null ? "" : ", ${address?.stateName}"}${address?.pincode == null ? "" : " - ${address?.pincode}"}';
    return formattedAddress;
  }
}
