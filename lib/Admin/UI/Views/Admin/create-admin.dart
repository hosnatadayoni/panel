import 'dart:convert';

import 'package:finance/Admin/Logic/Controllers/AdminController.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/connect-server-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Componenets/Items/Form/form-selectBox.dart';
import '../../Componenets/Items/Form/form-text-field.dart';
import '../../Componenets/btn.dart';

class CreateAdmin extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Rx<bool> isHoverBtnBack = false.obs;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
        ),
        child: Stack(
          children: [
            Obx((){
              return Positioned(
                right: Directionality.of(context) == TextDirection.rtl ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                left: Directionality.of(context) == TextDirection.ltr ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                child: Container(
                  width:size.width > 800 ? MainController.isClickedItem.value == true  ?(size.width) - 300:(size.width) - 50 : (size.width) - 50,
                  height: size.height,
                  padding: EdgeInsets.all(15),
                  color: MainController.isLightMode.value == false ? color6 :color9,
                  child:  ColumnScroll(
                    children: [
                      SizedBox(height: 80,),
                      Container(
                          padding: EdgeInsets.all(10),
                          width: size.width,
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            children: [
                              Btn(type: btnType.primary, isOutline: true, content: Txt(
                                '${AppController.of(context)!.value('back')}', fontSize: 16, fontWeight: FontWeight.w400,
                              ),onClick: () async {
                                Navigator.pop(context);
                              }),
                              SizedBox(width: 5,),
                              Btn(type: btnType.primary , content: Txt(
                                '${AppController.of(context)!.value('create')}',
                                color: whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                                  onClick: () async {
                                    print('_CreateAdminState.build>>>${json.encode(ViewController.request)}');
                                    if(ViewController.request.length!=0) {
                                      AdminController.storeAdmin(ViewController.request);
                                    }
                                    Navigator.pop(context);
                                  } , loadingTag: 'update-records'),
                            ],
                          )
                      ),

                      inputs('نام','name'),
                      inputs('نام کاربری','username'),
                      inputs('پسورد','password'),
                      selects(),
                      SizedBox(height: 20,),

                    ],
                  ),
                ),
              );
            }),
            Header(),
            MenuBox(),
          ],
        ),
      ),
    );
  }

  inputs(String name,String title){
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${name}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          );
        }),
        SizedBox(
          height: 10,
        ),
        FormTextField(
          name:  '${name}',
          hint:  '${name}',
          lable: '',
          column: null,
          onChange: (text) {
            if (text != null && text != '') {
              ViewController.request['${title}'] = text;
            } else {
              ViewController.request['${title}'] = '';
            }
          },
        ),
      ],
    );
  }
  selects(){
    var initvalue= AdminController.getRoleRes.length!=0? AdminController.getRoleRes.first['_id']:null;
    ViewController.request['role_id'] =initvalue;
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Txt(
          'نقش',
          color: MainController.isLightMode.value == true
              ? whiteColor
              : color2,
        ),
         SizedBox(height: 10,),
         SelectBox(
            name: 'نقش',
            items: [
              for (var item in AdminController.getRoleRes)
                DropdownMenuItem(
                    child: Obx(() {
                      return Txt(
                        '${item['name']}',
                        color:
                        MainController.isLightMode.value == true
                            ? whiteColor
                            : primaryDark,
                      );
                    }),
                    value: item['_id']),
            ],
            initalValue:ViewController.request['role_id']!=null? ViewController.request['role_id']:initvalue,
            onChanged: (value) async {

              if (value != '') {
                ViewController.request['role_id'] = value;
              } else {
                ViewController.request['role_id'] = initvalue;
              }
            },
            hintText: '',
            isSeleted: true.obs,
            selectedValue: ''),
      ],
    );
  }
}
