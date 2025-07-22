import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../manage_organization_controller.dart';
import 'bill_configuration_controller.dart';

class BillConfigurationView extends ConsumerStatefulWidget {
  const BillConfigurationView({
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BillConfigurationViewState();
}

class _BillConfigurationViewState extends ConsumerState<BillConfigurationView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(billConfigurationControllerProvider.notifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(manageOrganisationControllerProvider.notifier);
    ref.watch(manageOrganisationControllerProvider);
    return Scaffold();
  }
}
