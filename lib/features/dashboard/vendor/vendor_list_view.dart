import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/core/enums/user_type.dart';
import 'package:yoloworks_invoice/features/dashboard/client/client_list_view.dart';

class VendorListView extends ConsumerWidget {
  const VendorListView({super.key, this.isSelect = false});

  final bool isSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClientListView(
      usersType: UsersType.vendor,
      isSelect: isSelect,
    );
  }
}
