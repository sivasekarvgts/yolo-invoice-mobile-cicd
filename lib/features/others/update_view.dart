import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/common_widgets/button.dart';
import '../../locator.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/styles/text_styles.dart';
import '../../services/appconfig_service/appconfig_model.dart';

class UpdatePage extends ConsumerStatefulWidget {
  const UpdatePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdatePageState();
}

class _UpdatePageState extends ConsumerState<UpdatePage> {
  @override
  Widget build(BuildContext context) {
    AppUpdateDetails? androidUpdate =
        appConfigService.config.appUpdate?.android;
    AppUpdateDetails? iosUpdate = appConfigService.config.appUpdate?.iOS;
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: Image.network(
                    Platform.isIOS
                        ? iosUpdate!.imageLink!
                        : androidUpdate!.imageLink!,
                    fit: BoxFit.cover,
                  )),
              gapH20,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New Update is Available",
                        textScaler: TextScaler.linear(1),
                        style: AppTextStyle.titleMedium
                            .copyWith(color: Colors.black)),
                    gapH20,
                    Text(
                        (Platform.isIOS
                                ? iosUpdate?.updateMessage
                                : androidUpdate?.updateMessage) ??
                            'A new version of the app is available. Please update to enjoy the latest features and improvements',
                        style: AppTextStyle.bodyMedium,
                        textAlign: TextAlign.center),
                    gapH20,
                    AppButton(
                      'Update',
                      key: ValueKey('btnupdate'),
                      fullSize: false,
                      onPressed: () async {
                        if (await canLaunchUrl(Uri.parse((Platform.isIOS
                                ? iosUpdate?.url
                                : androidUpdate?.url) ??
                            ''))) {
                          await launchUrl(Uri.parse((Platform.isIOS
                                  ? iosUpdate?.url
                                  : androidUpdate?.url) ??
                              ''));
                        } else {
                          throw 'Could not launch ${(Platform.isIOS ? iosUpdate?.url : androidUpdate?.url) ?? ''}';
                        }
                      },
                    )
                  ],
                ),
              ),
              gapHcustom(MediaQuery.of(context).size.height / 3),
            ],
          )),
    );
  }
}
