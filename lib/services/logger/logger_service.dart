import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';
import 'package:yoloworks_invoice/core/extension/string_extension.dart';
import 'package:yoloworks_invoice/locator.dart';

import '../../app/common_widgets/app_text_field_widgets/app_text_field_widget.dart';
import '../../router.dart';
import '../../utils/debounce.dart';
import '../../utils/logger.dart';

part 'logger_service.g.dart';

class ShowLogMessages extends ConsumerStatefulWidget {
  const ShowLogMessages({super.key});

  @override
  ConsumerState createState() => _ShowLogMessageState();
}

class _ShowLogMessageState extends ConsumerState<ShowLogMessages> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(loggerControllerProvider.notifier);
      await controller.onInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(loggerControllerProvider.notifier);
    ref.watch(loggerControllerProvider);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                navigationService.pop();
              },
              icon: const Icon(Icons.close)),
          title: controller.isSearch
              ? AppTextFieldWidget(
                  inputBorder: InputBorder.none,
                  hintStyle: AppTextStyle.labelMedium,
                  ctrl: controller.textCtrl,
                  style: AppTextStyle.bodyLarge,
                  hintText: 'Search...',
                  borderRadius: 8,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                    controller.onSearch(text: controller.textCtrl.text);
                  },
                  onChanged: (val) => controller.onSearch(text: val))
              : null,
          actions: [
            IconButton(
                onPressed: () {
                  controller.isSearch = !controller.isSearch;
                  controller.historySearch.clear();
                  controller.onRefresh();
                },
                icon: controller.isSearch
                    ? Text(
                        'clear',
                        style: AppTextStyle.bodySmall
                            .copyWith(color: Colors.black),
                      )
                    : const Icon(Icons.search))
          ],
        ),
        body: _LoggerHistoryWidget(
            isSearch: !controller.isSearch,
            historyList: controller.isSearch
                ? controller.historySearch
                : controller.historyList));
  }
}

class _LoggerHistoryWidget extends StatelessWidget {
  const _LoggerHistoryWidget(
      {required this.historyList, required this.isSearch});
  final List<LogServiceParam> historyList;
  final bool isSearch;

  @override
  Widget build(BuildContext context) {
    if (historyList.isEmpty) {
      return const Center(child: Text('No Data'));
    }
    return ListView.separated(
        reverse: isSearch,
        itemBuilder: (_, i) {
          final service = historyList[i];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.circle,
                              size: 18, color: service.color),
                        ),
                        Text(service.type.capitalizeFirst!),
                      ],
                    ),
                    Text(service.time,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () => navigationService.pushNamed(Routes.logDetails,
                      arguments: service.message),
                  child: Text(
                    service.message,
                    maxLines: service.expanded ? null : 3,
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (_, i) => const Divider(),
        itemCount: historyList.length);
  }
}

class LogDetailsWidget extends StatelessWidget {
  const LogDetailsWidget({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () => navigationService.pop,
            icon: const Icon(Icons.close, color: Colors.grey))
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            InkWell(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: message));
                Fluttertoast.showToast(
                    msg: "Copied to Clipboard",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                    fontSize: 14.0);
              },
              // onTap: () async {
              //   await Clipboard.setData(
              //       ClipboardData(text: message));
              // },
              child: Text(message),
            ),
          ],
        ),
      ),
    );
  }
}

@riverpod
class LoggerController extends _$LoggerController {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  bool isSearch = false;
  List<LogServiceParam> historyList = [];
  List<LogServiceParam> historySearch = [];
  final textCtrl = TextEditingController();

  onInit() {
    onGetData();
  }

  void onGetData() {
    historyList = loggerService.logHistory;
    onRefresh();
  }

  void onSearch({String? text}) {
    Debounce.debounce('logger-search', () {
      isSearch = true;
      if (text?.isEmpty == true) {
        isSearch = false;
        textCtrl.clear();
        historySearch.clear();
        onRefresh();
        return;
      }

      final results = historyList
          .where((e) => e.message.toLowerCase().contains(text!.toLowerCase()))
          .toList();
      historySearch = results;
      onRefresh();
    });
  }

  void onRefresh() {
    state = AsyncValue.data(null);
  }
}
