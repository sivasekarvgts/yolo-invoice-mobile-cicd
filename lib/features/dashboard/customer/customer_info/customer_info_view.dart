import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/core/enums/user_type.dart';

import '../../client/client_info/client_info_view.dart';

class CustomerInfoView extends ConsumerWidget {
  const CustomerInfoView({super.key, required this.customerId});

  final int customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClientInfoView(clientId: customerId, usersType: UsersType.customer);
  }
}
