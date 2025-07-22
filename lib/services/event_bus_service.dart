import 'package:event_bus/event_bus.dart';

import '../features/sales/models/item_model/sales_line_item.dart';

class EventBusService {
  EventBus eventBus = EventBus();
}

class GlobalMessageHandler {
  String message;
  bool show;
  GlobalMessageHandler(this.message, {this.show = true});
}

// ignore: must_be_immutable
// class SalesOrderRefreshEvent extends Equatable {
//   bool? isRefresh;
//
//   SalesOrderRefreshEvent({this.isRefresh});
//
//   @override
//   String toString() {
//     return 'isRefresh $isRefresh';
//   }
//
//   @override
//   List<Object?> get props => [isRefresh];
// }
//
// class PaymentRefreshEvent extends Equatable {
//   final bool? isRefresh;
//   PaymentRefreshEvent({this.isRefresh});
//
//   @override
//   String toString() {
//     return 'isRefresh $isRefresh';
//   }
//
//   @override
//   List<Object?> get props => [isRefresh];
// }
//
class AddItemRefreshEvent {
  const AddItemRefreshEvent({required this.data});

  final List<SalesLineItem> data;
}

class PageRefreshEvent {
  const PageRefreshEvent({required this.pageNames, this.isRefresh = true});
  // Pass Route Name
  final List<String> pageNames;
  final bool isRefresh;
}
