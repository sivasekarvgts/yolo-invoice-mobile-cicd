import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/core/enums/user_type.dart';

import '../../client/client_info/client_info_view.dart';

class VendorInfoView extends ConsumerWidget {
  const VendorInfoView({super.key, required this.vendorId});

  final int vendorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClientInfoView(clientId: vendorId, usersType: UsersType.vendor);
  }
}
