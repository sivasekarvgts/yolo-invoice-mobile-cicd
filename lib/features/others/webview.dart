// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../app/styles/colors.dart';
// import '../../app/styles/light_theme.dart';
// import '../../app/styles/text_styles.dart';
//
// class SurgtestWebView extends ConsumerStatefulWidget {
//   final String title;
//   final String webUrl;
//   const SurgtestWebView({required this.title, required this.webUrl, super.key});
//
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _SurgtestWebViewState();
// }
//
// class _SurgtestWebViewState extends ConsumerState<SurgtestWebView> {
//   late WebViewController controller;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(AppColors.background)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {},
//           onPageStarted: (String url) {
//             setState(() {
//               _isLoading = true;
//             });
//           },
//           onPageFinished: (String url) {
//             setState(() {
//               _isLoading = false;
//             });
//           },
//           onWebResourceError: (WebResourceError error) {
//             setState(() {
//               _isLoading = false;
//             });
//           },
//           // onNavigationRequest: (NavigationRequest request) {
//           //   if (request.url.startsWith('https://www.surgtest.com/')) {
//           //     return NavigationDecision.prevent;
//           //   }
//           //   return NavigationDecision.navigate;
//           // },
//         ),
//       );
//     controller.loadRequest(Uri.parse(widget.webUrl));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: !_isLoading ,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             widget.title,
//             style: AppTextStyle.titleLarge.copyWith(color: AppColors.c000000),
//           ),
//         ),
//         body: Stack(
//           children: [
//             WebViewWidget(
//               controller: controller,
//             ),
//             if (_isLoading)
//               Center(
//                 child: LightTheme.customLoading2,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
