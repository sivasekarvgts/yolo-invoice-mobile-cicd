import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/core/enums/user_type.dart';
import 'package:yoloworks_invoice/features/dashboard/client/client_detail/client_detail_view.dart';

class VendorDetailView extends ConsumerWidget {
  const VendorDetailView({super.key, required this.vendorId});
  final int vendorId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClientDetailView(clientId: vendorId, usersType: UsersType.vendor);
  }
}
