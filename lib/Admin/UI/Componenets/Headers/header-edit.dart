import 'package:flutter/material.dart';

import '../../../Logic/Controllers/app-controller.dart';
import '../../../Logic/Controllers/helper-controller.dart';
import '../../../Logic/Controllers/main-controller.dart';
import '../../../Logic/Controllers/view-controller.dart';
import '../../../Public/styles.dart';
import '../General/txt.dart';
import '../btn.dart';
class HeaderEdit extends StatefulWidget {
  var data;
  var request;
  HeaderEdit({this.data,this.request}) ;

  @override
  State<HeaderEdit> createState() => _HeaderEditState();
}

class _HeaderEditState extends State<HeaderEdit> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return    Container(
        padding: EdgeInsets.all(10),
        width: size.width,
        child: Wrap(
          // mainAxisAlignment: MainAxisAlignment.end,
          alignment: WrapAlignment.end,
          children: [
            Btn(type: btnType.primary, isOutline: true, content: Txt(
              '${AppController.of(context)!.value('back')}', fontSize: 16, fontWeight: FontWeight.w400,
            ),onClick: () async {
              await MainController.loadData();
              await HelperController.goToTablePage(MainController.menuList[MainController.selectedSubItem.value].schema.name!);
            }),
            SizedBox(width: 5,),
            Btn(type: btnType.primary , content: Txt(
              '${AppController.of(context)!.value('edit')}',
              color: whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
                onClick: () async {
                  if(widget.request.length!=0) {
                    HelperController.editFunction('${MainController.infoSchema.value.schema.name}',id:'${widget.data!['_id']}' ,request:widget.request );
                  }
                  else{
                    await MainController.loadData();
                    await HelperController.goToTablePage(MainController.menuList[MainController.selectedSubItem.value].schema.name!);
                  }
                  // if (ViewController.isClickedBtn.value == false) {
                  //   await HelperController.goToTablePage(MainController.menuList[MainController.selectedSubItem.value]);
                  // }
                } , loadingTag: 'update-records'),
          ],
        )
    );
  }
}
