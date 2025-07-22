import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../features/splash_view.dart';
import '../../features/others/empty_view.dart';
import '../../features/others/maintaince.dart';
import '../../features/others/offline_view.dart';
import '../../features/others/update_view.dart';

import 'app/common_widgets/floating_bottom_nav_fab.dart';
import 'core/enums/user_type.dart';
import 'core/models/address_detail.dart';
import 'features/auth/view/login/login_view.dart';
import 'features/auth/view/login/shared/auth_view.dart';
import 'features/auth/view/manage_organization/manage_organization_view.dart';
import 'features/auth/view/select_organization/select_organization_view.dart';
import 'features/bill_preview/views/bill_preview.dart';
import 'features/charts_of_account/views/add_charts_accounts.dart';
import 'features/dashboard/client/new_client/add_address_view.dart';
import 'features/dashboard/client/new_client/add_new_client_view.dart';
import 'features/dashboard/client/new_client/contact_details_view.dart';
import 'features/dashboard/customer/customer_detail/customer_detail_view.dart';
import 'features/dashboard/customer/customer_info/customer_info_view.dart';
import 'features/dashboard/customer/customer_list_view.dart';
import 'features/dashboard/vendor/vendor_detail/vendor_details_view.dart';
import 'features/dashboard/vendor/vendor_info/vendor_info_view.dart';
import 'features/dashboard/vendor/vendor_list_view.dart';
// import 'features/dashboard/view/dashboard_view.dart';
import 'features/item/model/inventory_item_details_model.dart';
import 'features/item/view/item_detail/item_detail_view.dart';
import 'features/item/view/item_list/item_list_view.dart';
import 'features/item/view/hsn/select_hsn_list_view.dart';
import 'features/item/view/new_item/edit_item/item_edit_view.dart';
import 'features/item/view/new_item/item_create_view.dart';
import 'features/payment/payment_create/models/payment_params_request_model.dart';
import 'features/payment/payment_create/views/client_payment/payment_create.dart';
import 'features/payment/payment_create/views/vendor_payment/vendor_payment_create.dart';
import 'features/payment/payment_detail/views/payment_details_screen.dart';
import 'features/payment/payment_list/views/payment_list_screen.dart';
import 'features/payment/payment_list/views/receipt_list_screen.dart';
import 'features/purchase/view/purchase_invoice/purchase_invoice_view.dart';
import 'features/purchase/view/purchase_invoice_list/purchase_invoice_list_view.dart';
import 'features/purchase/view/purchase_order/purchase_order_view.dart';
import 'features/purchase/view/purchase_order_list/purchase_order_list_view.dart';
import 'features/sales/models/sales_params_request_model/sales_params_request_model.dart';
import 'features/sales/views/invoices/sales_invoice/sales_invoice.dart';
import 'features/sales/views/invoices/sales_invoice_list/sales_invoice_list_view.dart';
import 'features/sales/views/items/add_items/add_items_view.dart';
import 'features/sales/views/items/scheme_list/scheme_list_view.dart';
import 'features/sales/views/orders/sales_order_list/sales_order_list.dart';
import 'features/sales/views/orders/sales_order/sales_order.dart';
import 'features/sales/views/select_price_list/select_price_list.dart';
import 'features/sales/views/tds_tcs_view/add_tds_tcs_section.dart';
import 'services/logger/logger_service.dart';

class Routes {
  //
  static const String splash = "/";

  // Auth
  static const String login = "/auth/login";
  static const String authWeb = "/auth/login/auth-web-view";
  static const String selectOrganization = "/auth/select-organization";
  static const String manageOrganization =
      "/auth/dashboard/manage-organization";

  // Home
  static const String dashboard = "/auth/dashboard";
  static const String salesInvoiceList = "/auth/dashboard/sales-invoice-list";
  static const String salesOrderList = "/auth/dashboard/sales-Order-list";
  static const String receipt = "/auth/dashboard/receipt";
  static const String customer = "/auth/dashboard/customer";
  static const String item = "/auth/dashboard/item";
  static const String service = "/auth/dashboard/service";

  // purchase
  static const String vendor = "/auth/dashboard/vendor";
  static const String purchaseOrderList = "/auth/dashboard/purchase-order-list";
  static const String purchaseOrder = "/auth/dashboard/purchase-order";
  static const String purchaseInvoiceList =
      "/auth/dashboard/purchase-invoice-list";
  static const String purchaseInvoice = "/auth/dashboard/purchase-invoice";

  //sales
  static const String salesInvoice = "/auth/dashboard/sales-invoice";
  static const String salesOrder = "/auth/dashboard/sales-order";
  static const String itemList = "/auth/dashboard/item-list";
  static const String addItems = "/auth/dashboard/add-items";
  static const String orderList = "/auth/dashboard/order-list";
  static const String schemeList = "/auth/dashboard/scheme-list";
  static const String addTdsTcs = "/auth/dashboard/add-tds-tcs";
  static const String selectPriceList = "/auth/dashboard/select-price-list";
  static const String billPreview = "/auth/dashboard/bill-preview";

  //receipt
  static const String receiptList = "/auth/dashboard/receipt-list";

  //payment
  static const String paymentList = "/features/payment/payment-list";
  static const String paymentCreate = "/features/payment/payment-created";
  static const String paymentDetail = "/features/payment/payment-detail";
  static const String vendorPaymentCreate =
      "/features/payment/vendor-payment-created";

  //item
  static const String itemInventoryList =
      "/features/payment/item-inventory-list";
  static const String itemInventoryDetail =
      "/features/payment/item-inventory-Detail";
  static const String itemCreate = "/features/item/item-created";
  static const String itemEdit = "/features/item/item-edit";
  // static const String itemDetail = "/features/item/item-detail";
  static const String selectHsn = "/features/hsn-list";

  // client
  static const String addNewClient = "/auth/dashboard/client/add-new-client";
  static const String addAddress = "/auth/dashboard/client/add-address";
  static const String addContact = "/auth/dashboard/client/add-contact";
  static const String customerDetail = "/auth/dashboard/client/customer-detail";
  static const String vendorDetail = "/auth/dashboard/client/vendor-detail";
  static const String customerInfo = "/auth/dashboard/client/customer-Info";
  static const String vendorInfo = "/auth/dashboard/client/vendor-Info";

  //accounts
  static const String addAccounts = "/auth/dashboard/add-charts-accounts";

  //others
  static const String update = "/update";
  static const String showLogMessages = "/showLogMessages";
  static const String logDetails = "/logDetails";
  static const String maintenance = "/maintenance";
  static const String offline = "/offline";
  static const String error = "/notfound";
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (kDebugMode) {
      print("Route ${settings.name}");
    }
    //analyticsService.logScreenView(settings.name);

    switch (settings.name) {
      case Routes.showLogMessages:
        return CupertinoPageRoute(
          builder: (_) => ShowLogMessages(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.logDetails:
        return CupertinoPageRoute(
          builder: (_) => LogDetailsWidget(
            message: settings.arguments as String,
          ),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.splash:
        return CupertinoPageRoute(
          builder: (_) => const SplashView(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.update:
        return CupertinoPageRoute(
          builder: (_) => const UpdatePage(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.maintenance:
        return CupertinoPageRoute(
          builder: (_) => const MaintenancePage(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.offline:
        return CupertinoPageRoute(
          builder: (_) => const OfflinePage(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.login:
        return CupertinoPageRoute(
          builder: (_) => const LoginView(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.authWeb:
        return CupertinoPageRoute(
          builder: (_) => const AuthView(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.selectOrganization:
        return CupertinoPageRoute(
          builder: (_) => SelectOrganisationView(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.manageOrganization:
        return CupertinoPageRoute(
          builder: (_) => ManageOrganisationView(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.dashboard:
        return CupertinoPageRoute(
          builder: (_) =>  BottomTabBarView(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );

      case Routes.customer:
        return CupertinoPageRoute(
          builder: (_) => CustomerListView(
            isSelect:
                settings.arguments != null ? settings.arguments as bool : false,
          ),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.vendor:
        return CupertinoPageRoute(
          builder: (_) => VendorListView(
            isSelect: settings.arguments != null
                ? (settings.arguments as bool)
                : false,
          ),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.addNewClient:
        return CupertinoPageRoute(
          builder: (_) => AddNewClientView(
            addNewCustomerRouteArg: settings.arguments as AddNewClientRouteArg?,
          ),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.addAddress:
        return CupertinoPageRoute(
          builder: (_) => AddAddressView(
            addNewCustomerRouteArg: settings.arguments as AddNewClientRouteArg?,
          ),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.addContact:
        return CupertinoPageRoute(
          builder: (_) => const ContactDetailsView(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.customerDetail:
        return CupertinoPageRoute(
          builder: (_) => CustomerDetailView(
            customerId: settings.arguments as int,
          ),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.vendorDetail:
        return CupertinoPageRoute(
          builder: (_) => VendorDetailView(
            vendorId: settings.arguments as int,
          ),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.customerInfo:
        return CupertinoPageRoute(
          builder: (_) => CustomerInfoView(
            customerId: settings.arguments as int,
          ),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.vendorInfo:
        return CupertinoPageRoute(
          builder: (_) => VendorInfoView(
            vendorId: settings.arguments as int,
          ),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.salesOrderList:
        return CupertinoPageRoute(
          builder: (_) => SalesOrderList(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.salesInvoiceList:
        return CupertinoPageRoute(
          builder: (_) => SalesInvoiceListView(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.purchaseOrderList:
        return CupertinoPageRoute(
          builder: (_) => PurchaseOrderListView(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.purchaseInvoiceList:
        return CupertinoPageRoute(
          builder: (_) => PurchaseInvoiceListView(),
          settings: RouteSettings(
            name: settings.name,
          ),
        );
      case Routes.purchaseInvoice:
        return CupertinoPageRoute(
          builder: (_) => PurchaseInvoiceScreen(
            data: settings.arguments as SalesParamsRequestModel,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case Routes.salesOrder:
        return CupertinoPageRoute(
          builder: (_) => SalesOrderScreen(
            data: settings.arguments as SalesParamsRequestModel,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case Routes.salesInvoice:
        return CupertinoPageRoute(
          builder: (_) => SalesInvoiceScreen(
            data: settings.arguments as SalesParamsRequestModel,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case Routes.purchaseOrder:
        return CupertinoPageRoute(
          builder: (_) => PurchaseOrderView(
            data: settings.arguments as SalesParamsRequestModel,
          ),
          settings: RouteSettings(name: settings.name),
        );
      case Routes.selectPriceList:
        return CupertinoPageRoute(
          builder: (_) {
            if (settings.arguments == null)
              return SelectPriceList(priceList: [], selectedPriceList: null);
            final item = settings.arguments as Map<String, dynamic>;
            return SelectPriceList(
              priceList: item['price_list'] ?? [],
              selectedPriceList: item['selected_price_list'],
            );
          },
          settings: RouteSettings(name: settings.name),
        );
      case Routes.addItems:
        return CupertinoPageRoute(
          builder: (_) {
            return AddItemsView(
                addItemRequestModel: settings.arguments as AddItemRequestModel);
          },
          settings: RouteSettings(name: settings.name),
        );
      case Routes.schemeList:
        return CupertinoPageRoute(
          builder: (_) {
            final item = settings.arguments as Map;
            return SchemeListView(input: item);
          },
          settings: RouteSettings(name: settings.name),
        );
      case Routes.addTdsTcs:
        return CupertinoPageRoute(
          builder: (_) {
            if (settings.arguments == null) return AddTdsTcsSection();
            final item = settings.arguments as Map<String, dynamic>;
            return AddTdsTcsSection(input: item);
          },
          settings: RouteSettings(name: settings.name),
        );
      case Routes.billPreview:
        return CupertinoPageRoute(
          builder: (_) {
            final args = settings.arguments as BillPreviewArgs;
            return BillPreview(
              billPreviewArgs: args,
            );
          },
          settings: RouteSettings(name: settings.name),
        );
      case Routes.itemInventoryList:
        return CupertinoPageRoute(
          builder: (_) => ItemInventoryListView(),
          settings: RouteSettings(name: settings.name),
        );
       case Routes.itemInventoryDetail:
        return CupertinoPageRoute(
          builder: (_) => ItemDetailView(id: settings.arguments as int,),
          settings: RouteSettings(name: settings.name),
        );
      case Routes.itemCreate:
        return CupertinoPageRoute(
          builder: (_) => ItemCreateView( editDetails: settings.arguments as InventoryItemDetailsModel?,),
          settings: RouteSettings(name: settings.name),
        );
       case Routes.itemEdit:
        return CupertinoPageRoute(
          builder: (_) => ItemEditView( editDetails: settings.arguments as InventoryItemDetailsModel?,),
          settings: RouteSettings(name: settings.name),
        );
      case Routes.selectHsn:
        return CupertinoPageRoute(
          builder: (_) => SelectHsnListView(),
          settings: RouteSettings(name: settings.name),
        );
      case Routes.paymentList:
        return CupertinoPageRoute(
          builder: (_) => PaymentListScreen(),
          settings: RouteSettings(name: settings.name),
        );
      case Routes.receiptList:
        return CupertinoPageRoute(
          builder: (_) => ReceiptListScreen(),
          settings: RouteSettings(name: settings.name),
        );
      case Routes.paymentCreate:
        return CupertinoPageRoute(
          builder: (_) {
            final input = settings.arguments as PaymentParamsRequestModel;
            return PaymentCreate(input: input);
          },
          settings: RouteSettings(name: settings.name),
        );
      case Routes.vendorPaymentCreate:
        return CupertinoPageRoute(
          builder: (_) {
            final input = settings.arguments as PaymentParamsRequestModel;
            return VendorPaymentCreate(input: input);
          },
          settings: RouteSettings(name: settings.name),
        );
      case Routes.paymentDetail:
        return CupertinoPageRoute(
          builder: (_) => PaymentDetailScreen(data: settings.arguments as Map),
          settings: RouteSettings(name: settings.name),
        );
      case Routes.addAccounts:
        return CupertinoPageRoute(
          builder: (_) =>
              AddChartsAccounts(id: settings.arguments as List<int>),
          settings: RouteSettings(name: settings.name),
        );
      default:
        return TransparentRoute(builder: (context) => PageNotFound());
    }
  }
}

class NoTransitionRoute<T> extends CupertinoPageRoute<T> {
  NoTransitionRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class TransparentRoute extends PageRoute<void> {
  TransparentRoute({
    required this.builder,
    RouteSettings? settings,
  }) : super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );
  }
}

class NoPushTransitionRoute<T> extends CupertinoPageRoute<T> {
  NoPushTransitionRoute(
      {required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // is popping
    if (animation.status == AnimationStatus.reverse) {
      return super
          .buildTransitions(context, animation, secondaryAnimation, child);
    }
    return child;
  }
}

/// NoPopTransitionRoute
/// Custom route which has no transition when popped, but has a push animation
class NoPopTransitionRoute<T> extends CupertinoPageRoute<T> {
  NoPopTransitionRoute(
      {required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // is pushing
    if (animation.status == AnimationStatus.forward) {
      return super
          .buildTransitions(context, animation, secondaryAnimation, child);
    }
    return child;
  }
}

class RouteUtils {
  static RoutePredicate withNameLike(String name) {
    return (Route<dynamic> route) {
      return !route.willHandlePopInternally &&
          route is ModalRoute &&
          route.settings.name != null &&
          route.settings.name!.contains(name);
    };
  }
}

class AddNewClientRouteArg {
  AddNewClientRouteArg(
      {required this.usersType,
      this.isContactEdit,
      this.customerId,
      this.customerType});

  AddNewClientRouteArg.isContactEdit(
      {required this.usersType,
      this.isEdit = true,
      this.isContactEdit = true,
      this.name,
      this.phone,
      this.email,
      this.contactId,
      this.individualTypeEdit});

  AddNewClientRouteArg.isAddressEdit(
      {required this.usersType,
      this.isEdit = true,
      this.isContactEdit = false,
      this.customerId,
      this.addressList,
      this.sameAsShipping});

  final bool? isContactEdit;
  final UsersType usersType;
  bool? isEdit;
  int? customerId;
  int? customerType;
  bool? individualTypeEdit;
  int? contactId;
  String? phone;
  String? name;
  String? email;
  List<AddressDetail>? addressList;
  bool? sameAsShipping;
}

class ClientDetailArg {
  ClientDetailArg({required this.usersType, required this.clientId});

  final UsersType usersType;
  final int clientId;
}
