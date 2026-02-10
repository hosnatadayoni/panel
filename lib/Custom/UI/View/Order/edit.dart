import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:finance/Custom/Logic/controller.dart';
import 'package:finance/Custom/UI/Cumponent/Inputs/input.dart';
import 'package:finance/Custom/UI/View/Order/detail-create.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../Admin/Logic/Controllers/app-controller.dart';
import '../../../../Admin/Logic/Controllers/main-controller.dart';
import '../../../../Admin/Logic/Models/db.dart';
import '../../../../Admin/Public/styles.dart';
import '../../../../Admin/UI/Componenets/General/txt.dart';
import '../../../../Admin/UI/Componenets/Headers/header-create.dart';
import '../../../../Admin/UI/Componenets/Headers/header-edit.dart';
import '../../../../Admin/UI/Componenets/Items/Menu/menu.dart';
import '../../../../Admin/UI/Componenets/btn.dart';

class OrderEdit extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> products;

  const OrderEdit({
    Key? key,
    required this.users,
    required this.products,
  }) : super(key: key);

  @override
  _OrderEditState createState() => _OrderEditState();
}

class _OrderEditState extends State<OrderEdit> {
  RxString selectedCustomerItem=''.obs;
  // late RxString selectedCustomerItem;
  RxString typeSelect=''.obs;
  List<dynamic> types=[];
  RxMap<String,Widget> details=<String,Widget>{}.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    selectedCustomerItem.value = CustomController.orderRequest['customer']!=null?CustomController.orderRequest['customer']['_id']:'';
    typeSelect.value =  CustomController.orderRequest['type']!=null?CustomController.orderRequest['type']['value']:'';
    if(CustomController.orderRequest['customer']!=null){
      CustomController.orderRequest['customer']=CustomController.orderRequest['customer']['_id'];
    }
    types = MainController.getDetailsOfField('order', 'type') != null
        ? MainController.getDetailsOfField('order', 'type')['items']
        : [];

    // if (widget.users.isNotEmpty) {
    //   selectedCustomerItem.value = widget.users.first['_id'];
    //   typeSelect.value =
    //   types.isNotEmpty ? types.first['value'].toString() : '';
    // }
    if(CustomController.orderDetailRequest.length!=0) {
      print('_OrderEditState.initState');
        for (String orderDetail in CustomController.orderDetailRequest.keys) {
          details[orderDetail] = (DetailCreate(ky: orderDetail, products: widget.products));
        }
      }
    });
  }
  addDetails(){
    var uuid = Uuid();

    // تولید UUID نسخه 4 (Random)
    String ky = uuid.v4();
    details[ky]=(DetailCreate(ky: ky, products: widget.products));
    CustomController.orderDetailRequest[ky] = {};
  }
  @override
  Widget build(BuildContext context) {
    print('_OrderEditState.build>>${CustomController.orderRequest['image']}');
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Btn(type: btnType.primary, isOutline: true, content: Txt(
                        '${AppController.of(context)!.value('back')}', fontSize: 16, fontWeight: FontWeight.w400,
                      ),onClick: () async {
                        await MainController.loadData();
                        await HelperController.goToTablePage(MainController.getInfoTable('order'));
                        // Navigator.pop(context);
                      }),
                  Btn(type: btnType.primary , content: Txt(
                    '${AppController.of(context)!.value('edit')}',
                    color: whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),onClick: () async {
                    await HelperController.editFunction('order',id: CustomController.orderRequest['_id']);
                  }),
                      // InkWell(
                      //   onTap: () async {
                      //    await HelperController.editFunction('order',id: CustomController.orderRequest['_id']);
                      //   },
                      //   child: Text('ویرایش'),
                      // ),
                      // HeaderEdit(data: CustomController.orderRequest,request: CustomController.orderRequest),
                      Wrap(
                        children: [
                          Input(
                            width: 100,
                            lable: 'کد ورودی',
                            controller: TextEditingController(
                              text: CustomController.orderRequest['input_code']?.toString() ?? '',
                            ),
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
                            controller: TextEditingController(
                              text: CustomController.orderRequest['drawing_no']?.toString() ?? '',
                            ),
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
                            controller: TextEditingController(
                              text: CustomController.orderRequest['user_drawing_no']?.toString() ?? '',
                            ),
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
                          selectTableItem(selectedCustomerItem.value!=''?selectedCustomerItem.value:null, widget.users, (val){
                            selectedCustomerItem.value=val;
                            CustomController.orderRequest['customer']=selectedCustomerItem.value;
                          }),
                          SizedBox(
                            width: 10,
                          ),
                          selectCustomItem(typeSelect.value!=''?typeSelect.value:null, types,(val){
                            typeSelect.value=val;
                            CustomController.orderRequest['type']=typeSelect.value;
                          }),
                          SizedBox(
                            width: 20,
                          ),
                          ViewController.generateEditFileBox(CustomController.orderRequest, MainController.getDetailsOfField('order','image'), CustomController.orderRequest['image'] == null ? false.obs : true.obs),
                          // ViewController.generateFileBox(CustomController.orderRequest['image']??'', MainController.getDetailsOfField('order','image'), false.obs,onChange: (file){
                          //   CustomController.orderRequest['image']=file;
                          // }),
                          SizedBox(
                            width: 20,
                          ),

                          ViewController.generateFormDateBox(MainController.getDetailsOfField('order','date'),CustomController.orderRequest['date']!=null? CustomController.parseJalali(CustomController.orderRequest['date']):Jalali.now(), false.obs,onChange: (value){

                            CustomController.orderRequest['date']=value;

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
                      SingleChildScrollView(
                        child: Column(
                          children:[

                            for(String detail in details.keys)
                              Wrap(children: [
                                details[detail]!,
                                InkWell(
                                  onTap: () async {
                                    if(CustomController.orderDetailRequest[detail]!.containsKey('_id')){
                                      await DB('order_detail').where('_id', '\$eq', CustomController.orderDetailRequest[detail]!['_id']).deleteRecord();
                                    }
                                    CustomController.orderDetailRequest.remove(detail);

                                    details.remove(detail);
                                  },
                                  child: Text('حذف'),
                                )
                              ],)
                          ],
                        ),
                      )
                    ],
                  ),
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
      value: selectValue,
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
