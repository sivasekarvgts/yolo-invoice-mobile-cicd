import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/constants/app_sizes.dart';
import '../../app/constants/images.dart';
import '../../app/styles/colors.dart';
import '../../app/styles/text_styles.dart';
import '../../locator.dart';
import '../../services/appconfig_service/appconfig_model.dart';

class MaintenancePage extends ConsumerStatefulWidget {
  const MaintenancePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends ConsumerState<MaintenancePage> {
  AppMaintenance? appMaintenance = appConfigService.config.appMaintenance;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: AppColors.background,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 250, height: 200,child: SvgPicture.asset(Svgs.underMaintenance)),
                gapH20,
                Text("Down for Maintenance", textScaler: TextScaler.linear(1), style: AppTextStyle.titleMedium.copyWith(color: Colors.black, fontSize: 16)),
                gapH10,
                Text(appMaintenance?.updateMessage ?? '', style: AppTextStyle.titleMedium.copyWith(fontSize: 14), textAlign: TextAlign.center),
                gapH20,
                if (appMaintenance?.showButton == true)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    child: Text(
                      "More Info",
                      style: TextStyle(fontSize: 15, color: AppColors.background),
                    ),
                    onPressed: () async {
                      if (await canLaunchUrl(Uri.parse(appMaintenance?.externalUrl ?? ''))) {
                        await launchUrl(Uri.parse(appMaintenance?.externalUrl ?? ''));
                      } else {
                        throw 'Could not launch ${appMaintenance?.externalUrl}';
                      }
                    },
                  ),
              ],
            ),
          )),
    );
    
  }
}
