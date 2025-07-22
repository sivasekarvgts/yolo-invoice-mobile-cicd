import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/user_type.dart';
import '../client/client_list_view.dart';

class CustomerListView extends ConsumerWidget {
  const CustomerListView({super.key, this.isSelect = false});

  final bool isSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClientListView(
      usersType: UsersType.customer,
      isSelect: isSelect,
    );
  }
}
