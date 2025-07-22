import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/features/dashboard/view/dashboard_controller.dart';
import 'package:yoloworks_invoice/services/dialog_service/alert_response.dart';

import '../../../../locator.dart';

part 'customizable_links_controller.g.dart';


@riverpod
class CustomizableLinksController extends _$CustomizableLinksController  {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  int rowCount = 4;
  List<QuickLickModel> get quickLinks =>  allQuickLinks.where((element) => element.enabled==true,).toList();
  List<QuickLickModel>  allQuickLinks = [];


  onInit(){
    var copy = preferenceService
        .getDashboardLink()
        .map((e) => QuickLickModel.fromJson(e.toJson()))
        .toList();
    allQuickLinks = copy;
     setState;
  }

  void onSelect(int index){
    if(!allQuickLinks[index].enabled && quickLinks.length >= 4){
      Fluttertoast.showToast(msg:"You can select only maximum of 4");
      return;
    }

    allQuickLinks[index].enabled =! allQuickLinks[index].enabled;

    setState;
  }


  void onClearAll(){
    allQuickLinks.forEach((element) => element.enabled=false,);
    setState;
  }


  void onSave(){

    if(quickLinks.length < 4) {
      Fluttertoast.showToast(msg: "Select any 4 module to continue");
      return ;
    }

    preferenceService.setDashboardLink(allQuickLinks);
    dialogService.dialogComplete(AlertResponse(status: true));
  }
}