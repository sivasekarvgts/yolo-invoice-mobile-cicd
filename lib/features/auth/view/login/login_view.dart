import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/constants/images.dart';
import '../../../../app/common_widgets/button.dart';
import '../../../../app/common_widgets/app_loading_widget.dart';

import 'login_controller.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(loginControllerProvider.notifier);
      controller.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(loginControllerProvider.notifier);
    ref.watch(loginControllerProvider);
    return AppOverlayLoaderWidget(
      isLoading: controller.isLoading,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                SvgPicture.asset(Svgs.yoloBooks, width: 250),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    'Log In',
                    isLoading: controller.isLoading,
                    key: ValueKey('btnlogin'),
                    onPressed: () async {
                      await controller.login();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
