import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Logic/Models/order-item.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-checkBox.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-color.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-date.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-file.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-radio-button.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-time.dart';
import 'package:finance/Admin/UI/Views/table-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';

class FormEditOrderCustom extends StatefulWidget {

  FormEditOrderCustom( this.items , {this.data});
  var data;
  List<dynamic> items;

  @override
  State<FormEditOrderCustom> createState() => _FormEditOrderCustomState();
}

class _FormEditOrderCustomState extends State<FormEditOrderCustom> {

  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;
    Rx<bool> isHoverBtnBack = false.obs;

    return  Container(
      width: size.width,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(10),
              width: size.width,
              child: Wrap(
                // mainAxisAlignment: MainAxisAlignment.end,
                alignment: WrapAlignment.end,
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
                        MainController.isClickedItem.value = true;
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
                  InkWell(
                    onTap: ()async{
                      // await DB('Orders').where('id', '\$eq', '${widget.data!['id']}').updateRecords(ViewController.request);
                      //
                      // var orderItems=await DB('Order_Details').where('parent_id', '\$eq', '${widget.data!['_id']}').getRecords();
                      // for(var orderItem in  orderItems){
                      //   if(OrderItem.orderItemsList.containsKey(orderItem['_id'])){
                      //     DB('Order_Details').where('id', '\$eq', '${orderItem['_id']}').updateRecords(OrderItem.orderItemsList[orderItem['_id']]);
                      //   }
                      //   else{
                      //     DB('Order_Details').where('id', '\$eq', '${orderItem['_id']}').deleteRecord();
                      //   }
                      // }
                      // if (OrderItem.orderItemsList2.values.length != 0) {
                      //   for (var list in OrderItem.orderItemsList2.values) {
                      //     if(list.isNotEmpty){
                      //       await DB('Order_Details').parent(parentId:'${widget.data['_id']}' ,parentTable: 'Orders').storeRecord(list);
                      //
                      //     }
                      //   }
                      // }
                      // await MainController.loadData(tableData:ViewCustomController.getDataTable('Orders') );
                      // // MainController.renderPagination();
                      // MainController.goToTablePage(MainController.SubMenuList[MainController.selectedSubItem.value]);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: colorBtn,
                      ),
                      child: Txt('${AppController.of(context)!.value('edit')}' , color:whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
                    ),
                  ),
                ],
              )
          ),
          SizedBox(height: 20,),
          Container(
            width: size.width,
            padding: EdgeInsets.all(20),
            decoration:  BoxDecoration(
                border: Border.all(width: 2,color: MainController.isLightMode.value == true ? whiteColor:primaryDark),
                borderRadius:  BorderRadius.circular(10)
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'کد ورودی',
                            color:
                            MainController.isLightMode.value == true ? whiteColor : color2,
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 80,
                          child: FormTextField(
                            name: 'کد ورودی',
                            hint: 'کد ورودی',
                            lable: '',
                            initValue: '${widget.data['Input_Code'] != null ? widget.data['Input_Code']: ''}',
                            column: MainController.getDetailsOfField('Orders' , 'Input_Code'),
                            onChange: (text) {
                              widget.data['Input_Code']= text;
                            },
                            isNumberInt:true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'شماره نقشه',
                            color:
                            MainController.isLightMode.value == true ? whiteColor : color2,
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 80,
                          child: FormTextField(
                            name: 'شماره نقشه',
                            hint: 'شماره نقشه',
                            lable: '',
                            initValue: '${widget.data['Drawing_Number'] != null ? widget.data['Drawing_Number']: ''}',
                            column: MainController.getDetailsOfField('Orders' , 'Drawing_Number'),
                            onChange: (text) {
                                widget.data['Drawing_Number']= text;
                            },
                            isNumberInt:true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'شماره نقشه(مشتری)',
                            color:
                            MainController.isLightMode.value == true ? whiteColor : color2,
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 80,
                          child: FormTextField(
                            name: 'شماره نقشه(مشتری)',
                            hint: 'شماره نقشه(مشتری)',
                            initValue: '${widget.data['Drawing_Number(customer)'] != null ? widget.data['Drawing_Number(customer)']: ''}',
                            column: MainController.getDetailsOfField('Orders' , 'Drawing_Number(customer)'),
                            lable: '',
                            onChange: (text) {
                              widget.data['Drawing_Number(customer)']= text;
                            },
                            isNumberInt:true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'نوع',
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          child: SelectBox(
                              name: 'نوع',
                              column: MainController.getDetailsOfField('Orders' , 'Type'),
                              items: [
                                DropdownMenuItem(
                                    child: Obx(() {
                                      return Txt(
                                        '${AppController.of(Get.context!)!.value('not selected')}',
                                        color: MainController.isLightMode.value == true
                                            ? whiteColor
                                            : primaryDark,
                                      );
                                    }),
                                    value: ''),
                                for (var item in MainController.getDetailsOfField('Orders' , 'Type')['items'])
                                  DropdownMenuItem(
                                      child: Obx(() {
                                        return Txt(
                                          '${item['title']}',
                                          color:
                                          MainController.isLightMode.value == true
                                              ? whiteColor
                                              : primaryDark,
                                        );
                                      }),
                                      value: item['value']),
                              ],
                              initalValue: '${widget.data['Type']['value'] != null ? widget.data['Type']['value']: ''}',
                              onChanged: (value) async {
                                if (value != '') {
                                  widget.data['Type']['value'] = value;
                                } else {
                                  widget.data['Type']['value'] = '';
                                }
                              },
                              hintText: '',
                              isSeleted: widget.data['Type']['value'] != null ? true.obs : false.obs,
                              selectedValue: ''),
                        )
                      ],
                    ),
                    SizedBox(width: 20,),
                    ViewController.generateEditFileBox(widget.data, MainController.getDetailsOfField('Orders' , 'Picture'), widget.data['Picture'] != null ? true.obs : false.obs),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'مشتری',
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 250,
                          child: SelectBox(
                              name: 'مشتری',
                              column: MainController.getDetailsOfField('Orders' , 'Customer'),
                              items: [
                                DropdownMenuItem(
                                    child: Obx(() {
                                      return Txt(
                                        '${AppController.of(Get.context!)!.value('not selected')}',
                                        color: MainController.isLightMode.value == true
                                            ? whiteColor
                                            : primaryDark,
                                      );
                                    }),
                                    value: ''),
                                for (var item in widget.items)
                                  DropdownMenuItem(
                                      child: Obx(() {
                                        return Txt(
                                          '${ViewController.itemsShowSelectItem(item, MainController.getDetailsOfField('Orders' , 'Customer'))}',
                                          color:
                                          MainController.isLightMode.value == true
                                              ? whiteColor
                                              : primaryDark,
                                        );
                                      }),
                                      value: item['_id'].toString()),
                              ],
                              initalValue:'${widget.data['Customer']['_id']}',
                              onChanged: (value) async {
                                if (value != '') {
                                  widget.data['Customer']['_id'] = value;
                                } else {
                                  widget.data['Customer']['_id'] = '';
                                }
                              },
                              hintText: '',
                              isSeleted:  widget.data['Customer'] !=null ? true.obs : false.obs,
                              selectedValue: ''),
                        ),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Txt(
                            'تاریخ',
                            color:
                            MainController.isLightMode.value == true ? whiteColor : color2,
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 120,
                          child: DateBox(
                            selectedDate:  widget.data['Date'] != null ? ViewCustomController.parseDate('${widget.data['Date']}') : Jalali.now(),
                            isSeletedDate: widget.data['Date'] !=null ? true.obs : false.obs,
                            onDateChanged: (date) {
                              widget.data['Date'] = date;
                            },
                            column: MainController.getDetailsOfField('Orders' , 'Date'),
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}