import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/app/constants/strings.dart';
import 'package:yoloworks_invoice/core/extension/address_extenstion.dart';
import 'package:yoloworks_invoice/features/auth/view/manage_organization/manage_organization_controller.dart';
import 'package:yoloworks_invoice/locator.dart';
import 'package:yoloworks_invoice/router.dart';

import '../../../../app/common_widgets/brief_tile.dart';
import '../../../dashboard/client/client_list_view.dart';
import 'organization_info/organization_info_view.dart';

class ManageOrganisationView extends ConsumerStatefulWidget {
  const ManageOrganisationView({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManageOrganisationViewState();
}

class _ManageOrganisationViewState
    extends ConsumerState<ManageOrganisationView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller =
          ref.read(manageOrganisationControllerProvider.notifier);
      controller.init();
      // controller.fetchData(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(manageOrganisationControllerProvider.notifier);
    final state = ref.watch(manageOrganisationControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.manageOrganization.text),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: state.isLoading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: LoadingCardShimmerTile(),
                      )
                    : BriefTile(
                        onTap: () {
                          navigationService
                              .popAndPushNamed(Routes.selectOrganization);
                        },
                        title: controller.organizationInfo?.name ?? "UnKnown",
                        image: controller.organizationInfo?.logo ??
                            businessIndividualImages.randomBusinessImage,
                        subTitle: controller.organizationInfo?.addressDetail
                            ?.toCityAddressOne(),
                      )),
          ),
          Expanded(flex: 1, child: OrganizationInfoView())
        ],
      ),
    );
  }
}
