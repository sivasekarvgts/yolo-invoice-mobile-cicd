import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gst_info_ctrl.g.dart';

@riverpod
class GstInfoCtrl extends _$GstInfoCtrl {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);
  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  bool isSalesInvoice = false;

  Future onInit() async {
    
  }
}
