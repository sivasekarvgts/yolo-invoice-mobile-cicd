import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/features/dashboard/client/new_client/add_new_client_view.dart';

import '../../../../router.dart';

class AddNewVendorView extends ConsumerWidget {
  AddNewVendorView({super.key, this.addNewCustomerRouteArg});
  final AddNewClientRouteArg? addNewCustomerRouteArg;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AddNewClientView(
      addNewCustomerRouteArg: addNewCustomerRouteArg,
    );
  }
}
