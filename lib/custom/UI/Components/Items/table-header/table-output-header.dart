import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class TableOutPutHeader extends StatefulWidget {
  const TableOutPutHeader({Key? key}) : super(key: key);

  @override
  State<TableOutPutHeader> createState() => _TableOutPutHeaderState();
}

class _TableOutPutHeaderState extends State<TableOutPutHeader> {
  @override
  Widget build(BuildContext context) {
   RxInt count = RxInt(MainController.infoSchema.value.schema.countShowRow);

    return Obx((){
      return Container(
        padding: EdgeInsets.only(left: 10 , right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              child: FormTextField(
                  name: 'search',
                  lable: '${AppController.of(context)!.value('search')}...', onChange: (text){
                MainController.search(text);
                setState(() {
                  MainController.infoSchema.value.schema.currentPage = 1;
                });

              }),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () async{
                            count.value++;
                            MainController.infoSchema.value.schema.countShowRow = count.value;
                            MainController.infoSchema.value.schema.currentPage = 1;
                            if(ViewCustomController.ordersSelected.length != 0 && ViewCustomController.isClickedBtnRegister.value == true){
                              await HelperController.pageInateFunction();
                              for(var orderDetailSelected in MainController.dataRecord.value){
                                ViewCustomController.statusOrderDetails[orderDetailSelected['_id']] =  await ViewCustomController.getStatusOrderDetail(orderDetailSelected['_id']);
                              }
                            }
                            else{
                              MainController.dataRecord.value= await DB('${MainController.infoSchema.value.schema.name}').paginate();
                              ViewCustomController.getStatusOutPutOrders(MainController.dataRecord.value);
                            }


                          },
                          child: Icon(Icons.arrow_drop_up , color:  MainController.isLightMode.value == true?  whiteColor:color1,size: 20,),
                        ),
                        SizedBox(height: 0),
                        InkWell(
                          onTap: () async {
                            count.value--;
                            if(count.value < 10){
                              count.value =  10;
                            };
                            MainController.infoSchema.value.schema.countShowRow = count.value;
                            MainController.infoSchema.value.schema.currentPage = 1;
                            if(ViewCustomController.ordersSelected.length != 0 && ViewCustomController.isClickedBtnRegister.value == true){
                              await HelperController.pageInateFunction();
                              for(var orderDetailSelected in MainController.dataRecord.value){
                                ViewCustomController.statusOrderDetails[orderDetailSelected['_id']] =  await ViewCustomController.getStatusOrderDetail(orderDetailSelected['_id']);
                              }
                            }
                            else{
                              MainController.dataRecord.value= await DB('${MainController.infoSchema.value.schema.name}').paginate();
                              ViewCustomController.getStatusOutPutOrders(MainController.dataRecord.value);

                            }


                          },
                          child: Icon(Icons.arrow_drop_down , color:  MainController.isLightMode.value == true?  whiteColor:color1,size: 20,),
                        ),
                      ],
                    ),
                    SizedBox(width: 5),
                    Obx((){
                      return Container(
                        width: 25,
                        child: Text(
                          '${count.value}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: MainController.isLightMode.value == true?  whiteColor:color1,fontSize: 15),
                        ),
                      );
                    })
                  ],
                ),
                SizedBox(width: 5,),
                Row(
                  children: [
                    Txt('${AppController.of(context)!.value('show')}' , color: MainController.isLightMode.value == true?  whiteColor:color1, fontSize: 16, fontWeight: FontWeight.w400,),
                    SizedBox(width: 5,),
                    Txt('${AppController.of(context)!.value('input')}' , color: MainController.isLightMode.value == true?  whiteColor:color1, fontSize: 16, fontWeight: FontWeight.w400,),
                  ],
                ),
              ],
            ),


          ],
        ),
      );
    });
  }
}
