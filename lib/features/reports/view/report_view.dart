import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';
import 'package:yoloworks_invoice/features/reports/view/report_controller.dart';

class ReportView extends ConsumerStatefulWidget {
  const ReportView({super.key});

  @override
  ConsumerState createState() => _ReportViewState();
}

class _ReportViewState extends ConsumerState<ReportView> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(reportControllerProvider.notifier);
    final state = ref.watch(reportControllerProvider);
    final isLoading = state.isLoading;
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
        bottom: PreferredSize(
            preferredSize: Size.zero,
            child: Divider(height: 1,)),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(child: Text("Coming Soon...",style: AppTextStyle.darkBlackFS16FW500,))
        ],
      ),
    );
  }
}
