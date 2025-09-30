import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Public/images.dart';
import 'package:finance/Admin/UI/Componenets/General/img.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../Logic/Controllers/AdminController.dart';
import '../../Public/styles.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                  children: [ Positioned(
                    left:Directionality.of(context) == TextDirection.rtl ? 0 : null,
                    right: Directionality.of(context) == TextDirection.ltr ? 0 : null,
                    child: Container(
                      height: 500,
                      width: 210,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Directionality.of(context) == TextDirection.rtl ? 0 : 15),
                          topRight: Radius.circular(Directionality.of(context) == TextDirection.rtl ? 15 : 0),
                          bottomLeft: Radius.circular(Directionality.of(context) == TextDirection.rtl ? 0 : 15) ,
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
                            Txt('${AppController.of(context)!.value('login')}' , color: MainController.isLightMode.value == true ? whiteColor:color3, fontWeight: FontWeight.bold, fontSize: 22,),
                            SizedBox(height: 30,),
                            Container(
                                width: 370,
                                child: FormTextField(
                                  name: 'userName',
                                  lable: '${AppController.of(context)!.value('username')}' , hint: '${AppController.of(context)!.value('username')}' ,onChange: (text){
                                  AdminController.userModel.value.username = text;
                                },)),
                            SizedBox(height: 10,),
                            Container(
                                width: 370,
                                child: FormTextField(
                                  name: 'password',
                                  lable: '${AppController.of(context)!.value('password')}' , hint: '${AppController.of(context)!.value('password')}',onChange: (text){
                                  AdminController.userModel.value.password = text;
                                }, isPassword: true,fbKey: _fbKey,)),

                            SizedBox(height: 20,),
                            InkWell(
                              onTap: (){
                                if(AdminController.userModel.value.username!.trim().isEmpty ||  AdminController.userModel.value.password!.trim().isEmpty){
                                  showSnackbar(snackTypes.error,'${AppController.of(context)!.value('name or password cannot be empty')}');
                                }
                                // else{
                                //   if(AdminController.userName.value.length <10 || AdminController.password.value.length < 10){
                                //     showSnackbar(snackTypes.error,'${AppController.of(context)!.value('first and last name and password must be more than 10 characters')}');
                                //   }
                                  else{
                                    AdminController.login();
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
                                  child: Center(child: Txt('${AppController.of(context)!.value('login')}' , color:whiteColor, fontSize: 16, fontWeight: FontWeight.w400,textAlign: TextAlign.center,)),
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

