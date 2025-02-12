import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/dataController.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/validator-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Logic/Models/dataModel.dart';
import 'package:finance/UI/Componenets/General/loading.dart';
import 'package:finance/UI/Componenets/Items/Header/header.dart';
import 'package:finance/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/UI/Views/table-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:uuid/uuid.dart';
import '../../Public/styles.dart';
import '../../boxes.dart';
import '../Componenets/General/column-scroll.dart';
import '../Componenets/General/txt.dart';

class CreatePage extends StatefulWidget {
  CreatePage();

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  DateTime? startTime;

  DateTime? endTime;
  late Future<Widget> _future;
  Map<String , dynamic> dataJson = {};
  @override
  void initState() {
    super.initState();
    _future = ViewController.generateStoreFormView(dataJson); // ایجاد Future در initState
  }

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
              Obx(() {
                return  Positioned(
                    // right:MainController.isClickedItem.value == true ? 300 :50,
                    right: size.width > 800 ? MainController.isClickedItem.value == true ? 300 :50 : 50,
                    child: Container(
                      // width: MainController.isClickedItem.value == true  ?(size.width) - 300:(size.width) - 50,
                      width:size.width > 800 ? MainController.isClickedItem.value == true  ?(size.width) - 300:(size.width) - 50 : (size.width) - 50,
                      height: size.height,
                      color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
                      child: ColumnScroll(
                        children: [
                          SizedBox(height: 80,),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Txt('${AppController.of(context)!.value('add')}' , fontSize: 24 , fontWeight: FontWeight.w500, color:MainController.isLightMode.value == true ? whiteColor:primaryDark ,),
                                    SizedBox(width: 5,),
                                    Txt('${MainController.tableInfo['title']}' , fontSize: 24 , fontWeight: FontWeight.w500, color:MainController.isLightMode.value == true ? whiteColor:primaryDark ,),
                                  ],
                                ),
                                Obx((){
                                  return Row(
                                    children: [
                                      Row(
                                        children: [
                                          MouseRegion(
                                            onEnter: (_){
                                              isHoverBtnBack.value = true;
                                            },
                                            onExit: (_){
                                              isHoverBtnBack.value = false;
                                            },
                                            child: InkWell(
                                              onTap: (){

                                                Get.to(() => TablePage());
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  border: Border.all(color: colorBtn , width: 1),
                                                  color: isHoverBtnBack.value == false ? Colors.transparent : colorBtn,
                                                ),
                                                child: Txt('${AppController.of(context)!.value('back')}' , color:isHoverBtnBack.value == false ? colorBtn : whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          MouseRegion(
                                            onEnter: (_){
                                            },
                                            onExit: (_){
                                            },
                                            child: InkWell(
                                              onTap: () async{
                                                // startTime =  DateTime.now();
                                                // print('startTime>>>${startTime}');
                                                // for(var i=0;i<100000;i++){
                                                //   var Id =Uuid().v4();
                                                //   print("add record manual:${dataJson}");
                                                //   DataModel newData = DataModel(
                                                //     id: '${Id}',
                                                //     data: dataJson,
                                                //   );
                                                //   await box.add(newData);
                                                //   print('box.length>>>>${box.length}');
                                                //   dataController.allData.value.add(newData);
                                                //   print('newData.data${newData.data}');
                                                //
                                                // }
                                                // endTime = DateTime.now();
                                                // print('endTime>>>${endTime}');
                                                ViewController.isShowMessage.value = true;
                                                var Id =Uuid().v4();
                                                print("add record manual:${dataJson}");
                                                DataModel newData = DataModel(
                                                  id: '${Id}',
                                                  data: dataJson,
                                                );
                                                bool isValidator;
                                                List<bool> isValidatorList=[];
                                                print('newData.data>>>${newData.data}');
                                                for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
                                                  isValidator = ValidatorController.checkInputValidation(j,newData.data);
                                                  isValidatorList.add(isValidator);
                                                }
                                                print('isValidatorList>>>${isValidatorList}');
                                                bool isExsistsValidation = isValidatorList.contains(false);
                                                if(isExsistsValidation){
                                                  isValidatorList=[];
                                                }
                                                else{
                                                  await box.add(newData);
                                                  print('box.length>>>>${box.length}');
                                                  dataController.allData.value.add(newData);
                                                  print('newData.data${newData.data}');
                                                  await MainController.loadData();
                                                  MainController.renderPagination();
                                                  // }
                                                  Get.to(() => TablePage());
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  color: colorBtn,
                                                ),
                                                child: Txt('${AppController.of(context)!.value('save')}' , color:whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child:
                            FutureBuilder<Widget>(
                              future:_future,
                              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // در حال بارگذاری
                                } else if (snapshot.hasError) {
                                  return Text('خطا: ${snapshot.error}');
                                } else {
                                  return snapshot.data ?? Container(); // داده‌ها بارگذاری شده‌اند
                                }
                              },
                            )),

                        ],
                      ),
                    )
                );
              }),
              Header(title: ''),
              MenuBox(),
            ],
          )
      ),
    );
  }
}