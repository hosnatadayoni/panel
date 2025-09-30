import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Public/images.dart';
import 'package:finance/Admin/UI/Componenets/General/img.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/Admin/UI/Views/Admin/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import '../../../Logic/Controllers/AdminController.dart';
import '../../../Public/styles.dart';
import '../../Componenets/Items/Header/header.dart';
import '../../Componenets/Items/Menu/menu.dart';

class PasswordChange extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: Container(
        width: size.width,
        height: size.height,
        color:
            MainController.isLightMode.value == false ? primary : primaryDark,
        child: Stack(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    width: (0.4 * size.width),
                    height: size.height,
                    color: MainController.isLightMode.value == true
                        ? background
                        : whiteColor,
                    child: Stack(alignment: Alignment.center, children: [
                      Positioned(
                        left: Directionality.of(context) == TextDirection.rtl
                            ? 0
                            : null,
                        right: Directionality.of(context) == TextDirection.ltr
                            ? 0
                            : null,
                        child: Container(
                          // height: 500,
                          width: 210,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  Directionality.of(context) ==
                                          TextDirection.rtl
                                      ? 0
                                      : 15),
                              topRight: Radius.circular(
                                  Directionality.of(context) ==
                                          TextDirection.rtl
                                      ? 15
                                      : 0),
                              bottomLeft: Radius.circular(
                                  Directionality.of(context) ==
                                          TextDirection.rtl
                                      ? 0
                                      : 15),
                              bottomRight: Radius.circular(
                                  Directionality.of(context) ==
                                          TextDirection.rtl
                                      ? 15
                                      : 0),
                            ),
                            color: MainController.isLightMode.value == true
                                ? color8
                                : primary,
                          ),
                          // child: Img(loginSvg,
                          //     width: 100, height: 100, color: whiteColor),
                        ),
                      )
                    ]),
                  ),
                  Container(
                      width: (0.6 * size.width),
                      height: size.height,
                      color: MainController.isLightMode.value == true
                          ? background
                          : whiteColor,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            right:
                                Directionality.of(context) == TextDirection.rtl
                                    ? 0
                                    : null,
                            left:
                                Directionality.of(context) == TextDirection.ltr
                                    ? 0
                                    : null,
                            child: Container(
                              padding: EdgeInsets.all(15),
                              // height: 500,
                              // width: 500,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                      Directionality.of(context) ==
                                              TextDirection.rtl
                                          ? 15
                                          : 0),
                                  topRight: Radius.circular(
                                      Directionality.of(context) ==
                                              TextDirection.rtl
                                          ? 0
                                          : 15),
                                  bottomLeft: Radius.circular(
                                      Directionality.of(context) ==
                                              TextDirection.rtl
                                          ? 15
                                          : 0),
                                  bottomRight: Radius.circular(
                                      Directionality.of(context) ==
                                              TextDirection.rtl
                                          ? 0
                                          : 15),
                                ),
                                color: MainController.isLightMode.value == true
                                    ? background
                                    : whiteColor,
                                boxShadow: shadow,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Txt(
                                    'ویرایش رمز عبور',
                                    color:
                                        MainController.isLightMode.value == true
                                            ? whiteColor
                                            : color3,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                      width: 370,
                                      child: FormTextField(
                                        name: 'رمز عبور قدیم',
                                        lable: 'رمز عبور قدیم',
                                        hint: 'رمز عبور قدیم',
                                        onChange: (text) {
                                          AdminController.userModel.value
                                              .passwordOld = text;
                                        },
                                        isPassword: true,
                                      )),
                                  Container(
                                      width: 370,
                                      child: FormTextField(
                                        name: 'رمز عبور جدید',
                                        lable: 'رمز عبور جدید',
                                        hint: 'رمز عبور جدید',
                                        onChange: (text) {
                                          AdminController
                                              .userModel.value.password = text;
                                        },
                                        isPassword: true,
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.to(Profile());
                                        },
                                        child: Center(
                                          child: Container(
                                            width: 75,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: color11,
                                            ),
                                            child: Center(
                                                child: Txt(
                                              'بازگشت',
                                              color: whiteColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              textAlign: TextAlign.center,
                                            )),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      InkWell(
                                        onTap: () {
                                          if (AdminController
                                                      .userModel.value.password !=
                                                  null ||
                                              AdminController.userModel.value
                                                      .passwordOld !=
                                                  null) {
                                            if (AdminController
                                                    .userModel.value.password!
                                                    .trim()
                                                    .isNotEmpty ||
                                                AdminController
                                                    .userModel.value.passwordOld!
                                                    .trim()
                                                    .isNotEmpty) {
                                              AdminController.changePass();
                                            }
                                          }
                                          // else{
                                          //   if(AdminController.userName.value.length <10 || AdminController.password.value.length < 10){
                                          //     showSnackbar(snackTypes.error,'${AppController.of(context)!.value('first and last name and password must be more than 10 characters')}');
                                          //   }
                                          else {
                                            showSnackbar(snackTypes.error,
                                                '${AppController.of(context)!.value('name or password cannot be empty')}');
                                          }
                                        },
                                        child: Center(
                                          child: Container(
                                            width: 75,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: color11,
                                            ),
                                            child: Center(
                                                child: Txt(
                                              'ویرایش',
                                              color: whiteColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              textAlign: TextAlign.center,
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
            Header(),
            MenuBox(),
            // MenuBox(),
            // TableAccess()
          ],
        ),
      )),
    );
  }
}
