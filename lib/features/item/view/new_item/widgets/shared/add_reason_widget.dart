import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/app/common_widgets/empty_widget/error_text_widget.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/locator.dart';
import 'package:yoloworks_invoice/services/dialog_service/alert_response.dart';
import 'package:yoloworks_invoice/utils/debounce.dart';

import '../../../../../../app/common_widgets/app_text_field_widgets/sales_text_field_form_widget.dart';
import '../../item_create_controller.dart';

class AddReasonDialogWidget extends ConsumerStatefulWidget {
  const AddReasonDialogWidget({super.key});

  @override
  ConsumerState createState() => _AddReasonDialogWidgetState();
}

class _AddReasonDialogWidgetState extends ConsumerState<AddReasonDialogWidget> {

  final reasonController = TextEditingController();
  bool isLoading =false;
  bool status = true;
  @override
  void dispose() {
    // TODO: implement dispose
    reasonController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    Future createReason()async{
      final controller = ref.watch(itemCreateControllerProvider.notifier);
      isLoading=true;
      setState(() {});
      final res = await controller.createExemptionReason(reasonController.text);
      isLoading =false;
      res? dialogService.dialogComplete(AlertResponse(status: true)):status=false;
      setState(() {

      });
    }
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          gapH15,
          SalesTextFieldFormWidget(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autoFocus: true,
            ctrl: reasonController,
            label: 'Enter Exemption Reason',
            isOptional: false,
            onChanged: (v){
            Debounce.debounce("sds",(){
              setState(() {});
            });
            },
            isEnabled: true,
          ),
          gapH5,
         if(!status) ErrorTextWidget(
           errorText: "Failed to create!",
          ),
          gapH5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CupertinoButton(child: Text("Close"), onPressed: (){
                dialogService.dialogComplete(AlertResponse(status: false));
              }),
              IntrinsicHeight(
                  child: Container(
                    color: AppColors.greyColor300,width: 1,height: 30,
                  )),
              isLoading?CupertinoActivityIndicator(color: AppColors.primary,):
              CupertinoButton(child: Text("Save",style: TextStyle(color:reasonController.text.isEmpty?AppColors.greyColor500:null ),),onPressed: (){createReason();})
            ],
          )
        ],
      ),
    );
  }
}
