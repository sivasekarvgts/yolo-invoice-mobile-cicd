import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/core/enums/user_type.dart';
import 'package:yoloworks_invoice/features/dashboard/client/client_detail/client_detail_view.dart';

class CustomerDetailView extends ConsumerWidget {
  const CustomerDetailView({super.key, required this.customerId});
  final int customerId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClientDetailView(
        clientId: customerId, usersType: UsersType.customer);
  }
}
