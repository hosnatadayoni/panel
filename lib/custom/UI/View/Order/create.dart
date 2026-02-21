import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/Custom/Logic/controller.dart';
import 'package:finance/Custom/UI/Cumponent/Inputs/input.dart';
import 'package:finance/Custom/UI/View/Order/detail-create.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../Admin/Logic/Controllers/main-controller.dart';
import '../../../../Admin/Public/styles.dart';
import '../../../../Admin/UI/Componenets/Headers/header-create.dart';
import '../../../../Admin/UI/Componenets/Items/Menu/menu.dart';

class OrderCreate extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> products;

  const OrderCreate({
    Key? key,
    required this.users,
    required this.products,
  }) : super(key: key);

  @override
  _OrderCreateState createState() => _OrderCreateState();
}

class _OrderCreateState extends State<OrderCreate> {
  late RxString selectedCustomerItem;
  // late RxString selectedCustomerItem;
  late RxString typeSelect;
  late List<dynamic> types;

  @override
  void initState() {
    super.initState();

    selectedCustomerItem = ''.obs;
    typeSelect = ''.obs;

    types = MainController.getDetailsOfField('order', 'type') != null
        ? MainController.getDetailsOfField('order', 'type').items
        : [];

    if (widget.users.isNotEmpty) {
      selectedCustomerItem.value = widget.users.first['_id'];
      CustomController.orderRequest['customer']= widget.users.first['_id'];
      typeSelect.value =
      types.isNotEmpty ? types.first['value'].toString() : '';
    }
    CustomController.orderRequest['date']=Jalali.now().toString();
  }
  RxMap<String,Widget> details=<String,Widget>{}.obs;
  addDetails(){
    var uuid = Uuid();
    String ky = uuid.v4();
    details[ky]=(DetailCreate(ky: ky, products: widget.products));
    CustomController.orderDetailRequest[ky] = {};
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx( () {
          return Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MainController.isLightMode.value == false ? color6 : color9,
            ),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 350,top: 20,left: 20),
                  child: Column(
                    children: [
                      HeaderCreate("سفارشات"),
                      Wrap(
                        children: [
                          Input(
                            width: 100,
                            lable: 'کد ورودی',
                            isNumber: true,
                            hasBorder: true,
                            onChange: (value){
                            CustomController.orderRequest['input_code']=value;
                            },

                          ),
                          SizedBox(
                            width: 10,

                          ),
                          Input(
                            lable: 'شماره نقشه',
                            isNumber: true,
                            width: 100,
                            onChange: (value){
                              CustomController.orderRequest['drawing_no']=value;
                            },
                          ),
                          SizedBox(
                            width: 10,

                          ),
                          Input(
                            width: 100,
                            lable: 'شماره نقشه مشتری',
                            isNumber: true,
                            onChange: (value){
                              CustomController.orderRequest['user_drawing_no']=value;
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          selectTableItem(selectedCustomerItem.value, widget.users, (val){
                            selectedCustomerItem.value=val;
                            CustomController.orderRequest['customer']=selectedCustomerItem.value;
                          }),
                          SizedBox(
                            width: 10,
                          ),
                          selectCustomItem(typeSelect.value, types,(val){
                            typeSelect.value=val;
                            CustomController.orderRequest['type']=typeSelect.value;
                          }),
                          SizedBox(
                            width: 20,
                          ),
                          ViewController.generateFileBox(column:MainController.getDetailsOfField('order','image'),onChange: (file){
                            CustomController.orderRequest['image']=file;
                          }),
                          SizedBox(
                            width: 20,
                          ),
                          ViewController.generateFormDateBox(column: MainController.getDetailsOfField('order','date'),data:  Jalali.now(),onChange: (value){

                          CustomController.orderRequest['date']=value;
                          print('_OrderCreateState.build>>${value}>>${value.runtimeType}');
                            })
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('جزئیات سفارش'),
                          InkWell(
                            onTap: (){
                              if(CustomController.orderRequest.value.length!=0)
                              addDetails();
                              else
                                showSnackbar(snackTypes.error, 'ابتدا سفارش را تکمیل کنید');
                            },
                            child: Text('افزودن'),
                          )
                        ],
                      ),
                      Column(
                        children:[
                          for(String detail in details.keys)
                            Wrap(children: [
                              details[detail]!,
                              InkWell(
                                onTap: (){
                                  CustomController.orderDetailRequest.remove(detail);
                                  details.remove(detail);
                                },
                                child: Text('حذف'),
                              )
                            ],)
                        ],
                      )
                    ],
                  ),
                ),

                MenuBox(),
              ],
            ),
          );
        }
      ),
    );
  }
  Widget selectCustomItem(var selectValue, List<dynamic> listItems,Function onChange){

    return   DropdownButton<String>(
      hint: Text('یک گزینه انتخاب کنید'),
      value: selectValue.isEmpty ? null : selectValue,
      items: listItems.map((option) {
        return DropdownMenuItem<String>(
          value: option['value'],      // این مقداری هست که وقتی انتخاب شد برمی‌گرده
          child: Text(option['title']!), // این متنی هست که نمایش داده میشه
        );
      }).toList(),
      onChanged: (value) {
        onChange(value);


      },
    );
  }
  Widget selectTableItem(var selectValue,List<Map<String, dynamic>> listItems,Function onChange,{bool showEmptyItem=false}){

    Widget widget=Container();
    listItems.length!=0?
    widget= DropdownButton<String>(
      hint: showEmptyItem ? const Text("یک گزینه انتخاب کنید") : null,
      value: selectValue,
      items: listItems.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          value: item['_id'],
          child: Text(item['name']),
        );
      }).toList(),
      onChanged: (String? newId) {
        onChange(newId); // فقط parent رو مطلع می‌کنه
      },
    ):Container();
    return widget;
  }
}
