import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Helpers/token-methods.dart';
import 'package:finance/Admin/Public/images.dart';
import 'package:finance/Admin/UI/Componenets/General/img.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/Admin/UI/Views/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import '../../Public/styles.dart';
class SetTokenPage extends StatelessWidget {

  String? token;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Row(
          children: [
            Container(
              width: (0.4 * size.width),
              height: size.height,
              color:MainController.isLightMode.value == true ? color12:color5,
              child: Stack(
                  alignment: Alignment.center,
                  children: [Positioned(
                    left:Directionality.of(context) == TextDirection.rtl ? 0 : null,
                    right: Directionality.of(context) == TextDirection.ltr ? 0 : null,
                    child: Container(
                      height: 500,
                      width: 210,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Directionality.of(context) == TextDirection.rtl ? 0 : 15),
                          topRight: Radius.circular(Directionality.of(context) == TextDirection.rtl ? 15 : 0),
                          bottomLeft: Radius.circular(Directionality.of(context) == TextDirection.rtl ? 0: 15) ,
                          bottomRight: Radius.circular(Directionality.of(context) == TextDirection.rtl ? 15 : 0),),
                        color: MainController.isLightMode.value == true ? color8:primary,
                      ),
                      child: Img(loginSvg , width: 100, height: 100, color:  whiteColor),
                    ),
                  )]
              ),
            ),
            Container(
                width: (0.6 * size.width),
                height: size.height,
                color: MainController.isLightMode.value == true ? colorDropDown:color6,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      right:Directionality.of(context) == TextDirection.rtl ?  0 : null,
                      left:Directionality.of(context) == TextDirection.ltr ?  0 : null,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        height: 500,
                        width: 500,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Directionality.of(context) == TextDirection.rtl ? 15 : 0),
                            topRight: Radius.circular(Directionality.of(context) == TextDirection.rtl ? 0 : 15),
                            bottomLeft: Radius.circular(Directionality.of(context) == TextDirection.rtl ? 15 : 0) ,
                            bottomRight: Radius.circular(Directionality.of(context) == TextDirection.rtl ? 0 : 15),),
                          color: MainController.isLightMode.value == true ? background:whiteColor,
                          boxShadow: shadow,
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20,),
                            Container(
                                width: 370,
                                child: FormTextField(
                                  name: 'set-token',
                                  lable: '${AppController.of(context)!.value('Enter the token')}' ,
                                  hint: '' ,onChange: (text){
                                    token=text;
                                },)),
                            SizedBox(height: 20,),
                            InkWell(
                              onTap: () async {
                                print('SetTokenPage.build>>>${token}');
                                if(token!=null && token!.trim().length!=0) {
                                  await Token.setToken(token!);
                                  MainController.apiKey.value =token!;
                                  print('SetTokenPage.build iss>>>${ MainController.apiKey.value }');
                                  // await MainController.loadJson();
                                  // await MainController.loadData();
                                  Get.to(() => DashboardPage());
                                }
                                else{
                                  showSnackbar(snackTypes.error, AppController.of(context)!.value('Enter the token') );
                                }
                              },
                              child: Center(
                                child: Container(
                                  width: 75,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: color11,
                                  ),
                                  child: Center(child: Txt('${AppController.of(context)!.value('apply')}' , color:whiteColor, fontSize: 16, fontWeight: FontWeight.w400,textAlign: TextAlign.center,)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),)
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}