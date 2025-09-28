import 'package:finance/Admin/Logic/Controllers/AdminController.dart';
import 'package:finance/Admin/Logic/Controllers/connect-server-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Views/Route/create-route.dart';
import 'package:finance/Admin/UI/Views/Route/edit-route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Logic/Controllers/app-controller.dart';
import '../../../Logic/Controllers/view-controller.dart';
import '../../../Public/api-urls.dart';
import '../../../Public/config.dart';
import '../../../Public/styles.dart';
import '../../Componenets/General/txt.dart';
import '../../Componenets/Items/Form/form-checkBox.dart';
import '../../Componenets/Items/Form/form-text-field.dart';
import '../../Componenets/Items/Header/header.dart';
import '../../Componenets/Items/Menu/menu.dart';
import 'create-admin.dart';
import 'edit-admin.dart';

class TableAdmin extends StatefulWidget {
  @override
  State<TableAdmin> createState() => _TableAdminState();
}

class _TableAdminState extends State<TableAdmin> {

  @override
  Widget build(BuildContext context) {
    RxList<TableRow>rows=<TableRow>[].obs;
    Rx<bool> isHoverBtn = false.obs;
    var size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: size.width,
        height: size.height,
        color: MainController.isLightMode.value == false ? color6 : color9,
        child: Stack(
          children: [
            Positioned(
              right: Directionality.of(context) == TextDirection.rtl
                  ? size.width > 800
                      ? MainController.isClickedItem.value == true
                          ? 300
                          : 50
                      : 50
                  : 0,
              left: Directionality.of(context) == TextDirection.ltr
                  ? size.width > 800
                      ? MainController.isClickedItem.value == true
                          ? 300
                          : 50
                      : 50
                  : 0,
              child: Container(
                width: size.width > 800
                    ? MainController.isClickedItem.value == true
                        ? (size.width) - 300
                        : (size.width) - 50
                    : (size.width) - 50,
                padding: EdgeInsets.all(size.width > 800 ? 15 : 0),
                child: ColumnScroll(
                  children: [
                    SizedBox(
                      height: 80,
                    ),

                    Container(
                  padding: EdgeInsets.only(right: 10, left: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Txt(
                            'مدیریت مسیرها',
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : primaryDark,
                          )),
                      Row(
                        children: [
                          MouseRegion(
                            onEnter: (_) {
                              isHoverBtn.value = true;
                            },
                            onExit: (_) {
                              isHoverBtn.value = false;
                            },
                            child: InkWell(
                              onTap: () {
                              Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: colorBtn, width: 1),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: isHoverBtn.value == true
                                        ? colorBtn
                                        : Colors.transparent),
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_back,
                                        color: isHoverBtn.value == true
                                            ? whiteColor
                                            : colorBtn),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Txt(
                                      '${AppController.of(context)!.value('back')}',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color:
                                      isHoverBtn.value == true ? whiteColor : colorBtn,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          PopupMenuTheme(
                            data: PopupMenuThemeData(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(width: borderSize, color: itemColor34),
                              ),
                              color: MainController.isLightMode.value == true
                                  ? background
                                  : whiteColor,
                            ),
                            child: PopupMenuButton(
                              elevation: 0,
                              offset: Offset(0, 55),
                              onSelected: (value) {
                                setState(() {});
                              },
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuEntry>[
                                  PopupMenuItem(
                                      onTap: () {
                                        setState(() {
                                          ViewController.isClickedBtn.value = false;
                                          ViewController.isClickedEditBtn.value = false;
                                        });
                                        Future.delayed(Duration.zero, () async {
                                          await AdminController.getRoles();
                                          ViewController.request = {};
                                      Get.to(CreateAdmin());
                                        });
                                      },
                                      value: 'create',
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color:
                                              MainController.isLightMode.value == false
                                                  ? color3
                                                  : whiteColor,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Txt('${AppController.of(context)!.value('create')}',
                                                color: MainController.isLightMode.value ==
                                                    false
                                                    ? color3
                                                    : whiteColor)
                                          ],
                                        ),
                                      )),

                                ];
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: colorBtn, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: colorBtn,
                                ),
                                child: Row(
                                  children: [
                                    Txt(
                                      '${AppController.of(context)!.value('operation')}',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: 20,
                                      color: whiteColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                    SizedBox(
                      height: 25,
                    ),
                    TableHeaderRoute(),
                    SizedBox(
                      height: 25,
                    ),
                     LayoutBuilder(builder: (context, constraints) {
                        // هدر
                        final header = TableRow(
                          // decoration: BoxDecoration(color: Colors.blue.shade50),
                          children: [
                            HeaderCell('نام'),
                            HeaderCell('نام کاربری'),
                            HeaderCell('رمز عبور'),
                            HeaderCell('نقش'),
                            HeaderCell('غیرفعال'),
                            HeaderCell('عملیات'),
                          ],
                        );

                        // ردیف‌های دیتا

                        return Obx( () {
                           rows.value = (AdminController.getAdminRes)
                                .map<TableRow>((row) {
                                  return TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          row['name'] ?? '',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                MainController.isLightMode.value
                                                    ? whiteColor
                                                    : color1,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          row['username'] ?? '',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                MainController.isLightMode.value
                                                    ? whiteColor
                                                    : color1,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          row['password'] ?? '',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                MainController.isLightMode.value
                                                    ? whiteColor
                                                    : color1,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          row['role']!=null ? row['role']['name'] +'(${row['role']['description']})': '',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                MainController.isLightMode.value
                                                    ? whiteColor
                                                    : color1,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child:CheckBox(
                                          defaultValue: row['in_active'],
                                          checkBoxTitle: '',
                                          checkBoxName: '',
                                          onChange: (val) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: OperationView(row),
                                        ),
                                      ),
                                    ],
                                  );
                                })
                                .toList();

                            return Scrollbar(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: constraints.maxWidth,
                                    ),
                                    child: Table(
                                      border: TableBorder.all(
                                          color: MainController
                                                      .isLightMode.value ==
                                                  true
                                              ? whiteColor
                                              : color1),
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      columnWidths: const <int,
                                          TableColumnWidth>{
                                        0: IntrinsicColumnWidth(),
                                        1: IntrinsicColumnWidth(),
                                        2: IntrinsicColumnWidth(),
                                        3: IntrinsicColumnWidth(),
                                        4: IntrinsicColumnWidth(),
                                        5: IntrinsicColumnWidth(),
                                      },
                                      children: [header, ...rows],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    SizedBox(height: 20,),
                    TableFooterRoute(),
                  ],
                ),
              ),
            ),
            Header(),
            MenuBox(),
          ],
        ),
      ),
    );
  }
}

HeaderCell(String text) {
  return Padding(
    padding: const EdgeInsets.all(15),
    child: Align(
      alignment: Alignment.center,
      child: Txt(
        '${text}',
        color: MainController.isLightMode.value == true ? whiteColor : color1,
      ),
    ),
  );
}

OperationView(var data) {
  return Container(
    child: PopupMenuTheme(
      data: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(width: borderSize, color: itemColor34),
        ),
        color:
            MainController.isLightMode.value == true ? background : whiteColor,
      ),
      child: PopupMenuButton<String>(
        elevation: 0,
        offset: Offset(0, 55),
        onSelected: (String value) async {
          if (value == 'edit') {
            AdminController.getRoles();
            ViewController.request={};
            Get.to(EditAdmin(data: data,));
          }
          if (value == 'remove') {
            showDialog(
                context: Get.context!,
                builder: (BuildContext context) {
                  return Dialog(
                      child: Container(
                    width: 150,
                    height: 150,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        Txt('${AppController.of(context)!.value('Do you want this item to be removed?')}'),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: redColor),
                                child: Center(
                                    child: Txt(
                                  '${AppController.of(context)!.value('no')}',
                                  color: whiteColor,
                                )),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () async {
                                await ConncetServerController.deleteRoute(data['_id']);
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: successColor),
                                child: Center(
                                    child: Txt(
                                  '${AppController.of(context)!.value('yes')}',
                                  color: whiteColor,
                                )),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ));
                });
          }
        },
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
                value: 'edit',
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.edit,
                          color: MainController.isLightMode.value == true
                              ? whiteColor
                              : color3),
                      SizedBox(
                        width: 5,
                      ),
                      Txt('${AppController.of(context)!.value('edit')}',
                          color: MainController.isLightMode.value == false
                              ? color3
                              : whiteColor)
                    ],
                  ),
                )),
            PopupMenuItem<String>(
                value: 'remove',
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.trash,
                        color: MainController.isLightMode.value == true
                            ? whiteColor
                            : color3,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Txt('${AppController.of(context)!.value('remove')}',
                          color: MainController.isLightMode.value == false
                              ? color3
                              : whiteColor)
                    ],
                  ),
                )),
          ];
        },
        child: Container(
          width: 100,
          height: 45,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: colorBtn, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: colorBtn,
          ),
          child: Row(
            children: [
              Txt(
                '${AppController.of(Get.context!)!.value('operation')}',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: whiteColor,
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.arrow_drop_down_sharp,
                size: 20,
                color: whiteColor,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
class TableHeaderRoute extends StatefulWidget {

  @override
  State<TableHeaderRoute> createState() => _TableHeaderRouteState();
}

class _TableHeaderRouteState extends State<TableHeaderRoute> {
  List<int> showInfo = [10 , 25 , 50 , 100];
  int  selectedCount =  10;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.only(left: 15 , right: 15),
        width:size.width ,
        child: size.width > 600 ?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Txt('${AppController.of(context)!.value('show')}' , color: MainController.isLightMode.value == true?  whiteColor:color1, fontSize: 16, fontWeight: FontWeight.w400,),
                SizedBox(width: 5,),
                Container(
                  width: 70,
                  child: PopupMenuTheme(
                    data: PopupMenuThemeData(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
                        side: BorderSide(width: borderSize , color: itemColor34),
                      ),
                      color:MainController.isLightMode.value == true? background:whiteColor,
                    ),
                    child: PopupMenuButton<int>(
                      elevation: 0,
                      offset: Offset(0, 45),
                      onSelected: (value) async {
                        // setState(() {
                          ConncetServerController.countShowRowRoute.value = value;
                          selectedCount = value;
                          MainController.startIndex.value = (ConncetServerController.currentPageRoute.value-1) * ConncetServerController.countShowRowRoute.value;
                          MainController.endIndex.value = MainController.startIndex.value +ConncetServerController.countShowRowRoute.value;
                          ConncetServerController.currentPageRoute.value = 1;
                        //   // MainController.renderPagination();
                        // });
                      await ConncetServerController.getRoute();
                      },
                      itemBuilder: (BuildContext context) {
                        return showInfo.map((item) {
                          return PopupMenuItem<int>(
                            value: item,
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Txt(
                                    '$item',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: MainController.isLightMode.value == true ? whiteColor : color1,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: MainController.isLightMode.value == true? whiteColor : color1 ),
                          borderRadius: BorderRadius.circular(16),
                          color: MainController.isLightMode.value == true? background : whiteColor,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_drop_down_sharp , size: 20, color:  color1,),
                            SizedBox(width: 5,),
                            Obx(() {
                                return Txt('${ConncetServerController.countShowRowRoute.value}' , fontSize: 14 , fontWeight: FontWeight.w700, color: MainController.isLightMode.value == true? whiteColor : color1);
                              }
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Txt('${AppController.of(context)!.value('row')}' , color: MainController.isLightMode.value == true?  whiteColor:color1, fontSize: 16, fontWeight: FontWeight.w400,)
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Txt('${AppController.of(context)!.value('search')}:' , fontSize: 16, fontWeight: FontWeight.w400,color: MainController.isLightMode.value == true ? whiteColor:color1, ),
                      SizedBox(width: 5,),
                      Container(
                        margin:EdgeInsets.only(top: 27) ,
                        width: 200,
                        child: FormTextField(
                            name: 'search',
                            lable: '${AppController.of(context)!.value('search')}...', onChange: (text){
                          MainController.search(text);
                          setState(() {
                            ConncetServerController.currentPageRoute.value = 1;
                          });

                        }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ):
        Column(
          children: [
            Row(
              // crossAxisAlignment: WrapCrossAlignment.center,

              children: [
                Txt('${AppController.of(context)!.value('show')}' , color: MainController.isLightMode.value == true?  whiteColor:color1, fontSize: 16, fontWeight: FontWeight.w400,),
                SizedBox(width: 5,),
                Container(
                  width: 70,
                  child: PopupMenuTheme(
                    data: PopupMenuThemeData(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
                        side: BorderSide(width: borderSize , color: itemColor34),
                      ),
                      color:MainController.isLightMode.value == true? background:whiteColor,
                    ),
                    child: PopupMenuButton<int>(
                      elevation: 0,
                      offset: Offset(0, 45),
                      onSelected: (value) async {

                          ConncetServerController.countShowRowRoute.value = value;
                          selectedCount = value;
                          MainController.startIndex.value = (ConncetServerController.currentPageRoute.value-1) *10;
                          MainController.endIndex.value = MainController.startIndex.value + 10;
                          ConncetServerController.currentPageRoute.value =1;

                        await ConncetServerController.getRoute();
                      },
                      itemBuilder: (BuildContext context) {
                        return showInfo.map((item) {
                          return PopupMenuItem<int>(
                            value: item,
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Txt(
                                    '$item',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: MainController.isLightMode.value == true ? whiteColor : color1,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: MainController.isLightMode.value == true? whiteColor : color1 ),
                          borderRadius: BorderRadius.circular(16),
                          color: MainController.isLightMode.value == true? background : whiteColor,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_drop_down_sharp , size: 20, color:  color1,),
                            SizedBox(width: 5,),
                            Txt('${ConncetServerController.countShowRowRoute.value}' , fontSize: 14 , fontWeight: FontWeight.w700, color: MainController.isLightMode.value == true? whiteColor : color1),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Txt('${AppController.of(context)!.value('row')}' , color: MainController.isLightMode.value == true?  whiteColor:color1, fontSize: 16, fontWeight: FontWeight.w400,)
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Txt('${AppController.of(context)!.value('search')}:' , fontSize: 16, fontWeight: FontWeight.w400,color: MainController.isLightMode.value == true ? whiteColor:color1, ),
                      SizedBox(width: 5,),
                      Container(
                        width: 200,
                        child: FormTextField(
                            name: 'search',
                            lable: '${AppController.of(context)!.value('search')}...', onChange: (text){
                          MainController.search(text);
                            ConncetServerController.currentPageRoute.value = 1;
                        }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        )
    );
  }
}
class TableFooterRoute extends StatefulWidget {

  @override
  State<TableFooterRoute> createState() => _TableFooterRouteState();
}

class _TableFooterRouteState extends State<TableFooterRoute> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var tableSelected = 'route';

    return Obx((){
      return Container(
        child: size.width > 556 ?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: pagenationBox(ViewController.totalPage.value , tableSelected),
        ) :
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: pagenationBox(ViewController.totalPage.value , tableSelected),
        ),);
    });
  }
  Widget box(int i , tableSelected){
    Rx<bool> isHover = false.obs;
    return MouseRegion(
      onEnter: (_){
        isHover.value = true;
      },
      onExit: (_){
        isHover.value = false;
      },
      child: InkWell(
        onTap: ()async{
          setState(() {
            ConncetServerController.currentPageRoute.value = i;
          });
          print('_TableFooterState.box currentPage>>>${ ConncetServerController.currentPageRoute.value}');
          await ConncetServerController.getRoute();

        },
        child: Container(
            margin: EdgeInsets.only(right: Directionality.of(context) == TextDirection.ltr ? 5  : 0 , left:Directionality.of(context) == TextDirection.rtl ? 5  : 0  ),
            width: 40,
            height: 40,
            child: Obx((){
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:isHover.value == true  ? colorBtn:i ==ConncetServerController.currentPageRoute.value ? colorBtn : Colors.blue,
                ),
                child: Center(child: Txt('${i}', textAlign: TextAlign.center , color: whiteColor,)),
              );
            })
        ),
      ),
    );
  }

  List<Widget> pagenationBox(totalPages , tableSelected){
    print('_TableFooterRouteState.pagenationBox${totalPages}');
    var size = MediaQuery.of(context).size;

    return [
      Obx((){
        return Container(
          padding: EdgeInsets.only(left: 40, right: 40),
          child: Row(
            children: [
              Txt('${AppController.of(context)!.value('show')}',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: color3,),
              Txt('${ConncetServerController.getRouteRes.value.length == 0
                  ? 0
                  : MainController.startIndex.value + 1}',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: color3,),
              Txt('${AppController.of(context)!.value('until')}',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: color3,),
              Txt('${MainController.endIndex.value}', fontSize: 16,
                fontWeight: FontWeight.w400,
                color: color3,),
              Txt('${AppController.of(context)!.value('from')}',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: color3,),
              Txt('${MainController.totalItems.value}',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: color3,),
              Txt('${AppController.of(context)!.value('row')}',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: color3,),
            ],
          ),
        );
      }),
      size.width > 556 ?
      Expanded(child: Wrap(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(5)),
              color: ConncetServerController.currentPageRoute.value > 1
                  ? color3
                  : color7,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(15)),
              onPressed: ConncetServerController.currentPageRoute.value > 1 ? () async {
                setState(() {
                  ConncetServerController.currentPageRoute.value--;
                });
                // MainController.tableData.value= await DB('${tableSelected}').paginate();
              } : null,
              child: Txt('${AppController.of(context)!.value(
                  'previous')}', color: ConncetServerController.currentPageRoute.value > 1
                  ? whiteColor
                  : color3),
            ),
          ),
          SizedBox(width: 5,),
          if (totalPages > 5) ...[
            box(1, tableSelected),
            box(2, tableSelected),
            SizedBox(width: 5),
            Container(
              margin: EdgeInsets.only(right: Directionality.of(context) == TextDirection.ltr ? 5  : 0 , left:Directionality.of(context) == TextDirection.rtl ? 5  : 0  ),
              width: 40,
              height: 40,
              child: Center(child: Txt('...', fontSize: 20)),
            ),
            SizedBox(width: 5),
            box(totalPages - 1, tableSelected),
            box(totalPages, tableSelected),
          ] else ...[
            for (var i = 1; i <= totalPages; i++)
              box(i, tableSelected),
          ],
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(5)),
              color: ConncetServerController.currentPageRoute.value <
                  totalPages
                  ? color3
                  : color7,
            ),
            child: Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(15)),
                onPressed: ConncetServerController.currentPageRoute.value <
                    totalPages ? () async {
                  setState(() {
                    ConncetServerController.currentPageRoute.value++;
                  });
                  // MainController.tableData.value= await DB('${tableSelected}').paginate();

                } : null,
                child: Txt(
                  '${AppController.of(context)!.value('next')}',
                  color: ConncetServerController.currentPageRoute.value<
                      totalPages
                      ? whiteColor
                      : color3,),
              ),
            ),
          ),
        ],
      )):
      Container(
        padding: EdgeInsets.only(left: 40, right: 40),
        child: Wrap(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(5)),
                color: ConncetServerController.currentPageRoute.value > 1
                    ? color3
                    : color7,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(15)),
                onPressed: ConncetServerController.currentPageRoute.value > 1 ? () async {
                  setState(() {
                    ConncetServerController.currentPageRoute.value--;
                  });
                  await ConncetServerController.getRoute();
                  // MainController.renderPagination();
                  // MainController.tableData.value= await DB('${tableSelected}').paginate();
                } : null,
                child: Txt('${AppController.of(context)!.value(
                    'previous')}', color: ConncetServerController.currentPageRoute.value > 1
                    ? whiteColor
                    : color3),
              ),
            ),
            SizedBox(width: 5,),
            if (totalPages > 5) ...[
              box(1, tableSelected),
              box(2, tableSelected),
              SizedBox(width: 5),
              Container(
                margin: EdgeInsets.only(right: Directionality.of(context) == TextDirection.ltr ? 5  : 0 , left:Directionality.of(context) == TextDirection.rtl ? 5  : 0  ),
                width: 40,
                height: 40,
                child: Center(child: Txt('...', fontSize: 20)),
              ),
              SizedBox(width: 5),
              box(totalPages - 1, tableSelected),
              box(totalPages, tableSelected),
            ] else ...[
              for (var i = 1; i <= totalPages; i++)
                box(i, tableSelected),
            ],
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(5)),
                color: ConncetServerController.currentPageRoute.value <
                    totalPages
                    ? color3
                    : color7,
              ),
              child: Container(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15)),
                  onPressed: ConncetServerController.currentPageRoute.value <
                      totalPages ? () async {
                    setState(() {
                      ConncetServerController.currentPageRoute.value++;
                    });
                    await ConncetServerController.getRoute();

                    // MainController.renderPagination();
                    // MainController.tableData.value= await DB('${tableSelected}').paginate();

                  } : null,
                  child: Txt(
                    '${AppController.of(context)!.value('next')}',
                    color: ConncetServerController.currentPageRoute.value <
                        totalPages
                        ? whiteColor
                        : color3,),
                ),
              ),
            ),
          ],
        ),
      )
    ];

  }

}