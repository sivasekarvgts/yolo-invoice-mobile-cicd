import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_controller.g.dart';

@riverpod
class TransactionsController extends _$TransactionsController
{
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();


  comingSoon(){
    Fluttertoast.showToast(msg:"Coming Soon",gravity: ToastGravity.CENTER);
  }
}