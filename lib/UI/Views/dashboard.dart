// import 'package:finance/Logic/Controllers/app-controller.dart';
// import 'package:finance/Logic/Controllers/main-controller.dart';
// import 'package:finance/Public/styles.dart';
// import 'package:finance/UI/Componenets/General/column-scroll.dart';
// import 'package:finance/UI/Componenets/General/txt.dart';
// import 'package:finance/UI/Componenets/Items/Dashboard/dashboard-box.dart';
// import 'package:finance/UI/Componenets/Items/Dashboard/dashboard-info.dart';
// import 'package:finance/UI/Componenets/Items/Dashboard/dashboard-info2.dart';
// import 'package:finance/UI/Componenets/Items/Dashboard/dashboard-info3.dart';
// import 'package:finance/UI/Componenets/Items/Dashboard/line-chart.dart';
// import 'package:finance/UI/Componenets/Items/Dashboard/circle-progress-bar.dart';
// import 'package:finance/UI/Componenets/Items/Header/header.dart';
// import 'package:finance/UI/Componenets/Items/Menu/menu.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// // import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
//
//
// class DashboardPage extends StatelessWidget {
//   const DashboardPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Obx((){
//         return Container(
//           width: size.width,
//           // height: size.height,
//           color: MainController.isLightMode.value == false ? color6 :color9,
//           child: Stack(
//             children: [
//               Header(),
//               SizedBox(height: 20,),
//               Positioned(
//                 right: size.width > 800 ? MainController.isClickedItem.value == true ? 320 : 50 : 50,
//                 top: 100,
//                 child: Container(
//                   padding: EdgeInsets.all(20),
//                   width: size.width > 800
//                       ? MainController.isClickedItem.value == true
//                       ? (size.width) - 350
//                       : (size.width) - 50
//                       : (size.width) - 50,
//                   height: size.height,
//
//                   child: ColumnScroll(
//                     children: [
//                       Container(
//                         width: size.width,
//                         child: Wrap(
//                           spacing: 20,
//                           runSpacing: 20,
//                           alignment: WrapAlignment.start,
//                           children: [
//                             DashboardBox(icon: Icons.supervised_user_circle_outlined, count: 21, text: '${AppController.of(context)!.value('canceled orders')}', index: 0),
//                             DashboardBox(icon: Icons.shield_moon_rounded, count: 0, text: '${AppController.of(context)!.value('unverified drivers')}', index: 1),
//                             DashboardBox(icon: Icons.supervised_user_circle_sharp, count: 118, text: '${AppController.of(context)!.value('number of users')}', index: 2),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                       Container(
//                         padding: EdgeInsets.all(30),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(15)),
//                           color: MainController.isLightMode.value == true ? background : whiteColor,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Txt('${AppController.of(context)!.value('visit of the week')}',
//                               color: MainController.isLightMode.value == true ? whiteColor : color1,
//                             ),
//                             SizedBox(height: 10),
//                             Container(
//                               height: 200,
//                               width: size.width,
//                               child: WeeklyChart(),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                       Container(
//                         width: size.width,
//                         child: Wrap(
//                           spacing: 20,
//                           runSpacing: 20,
//                           alignment: WrapAlignment.start,
//                           children: [
//                             DashboardInfo(count: '72525' , description: 'No of Visits' , color: Colors.green , icon: Icons.supervised_user_circle,),
//                             DashboardInfo(count: '11255' , description: 'Comments' , color: Colors.lightBlueAccent , icon: CupertinoIcons.chat_bubble_2_fill,),
//                             DashboardInfo(count: '25550' , description: 'Salers' , color: Colors.orangeAccent , icon: CupertinoIcons.shopping_cart,),
//                             DashboardInfo(count: '16150' , description: 'Daily Visits' , color: redColor , icon: CupertinoIcons.eye,),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                       Container(
//                         width: size.width,
//                         child: Wrap(
//                           spacing: 20,
//                           runSpacing: 20,
//                           alignment: WrapAlignment.start,
//                           children: [
//                             DashboardInfo2(title: 'Salers', color: Colors.yellow, num: 55),
//                             DashboardInfo2(title: 'Customers', color: Colors.greenAccent, num: 84),
//                             DashboardInfo2(title: 'No. of Visits', color: warningColor, num: 46),
//                             DashboardInfo2(title: 'Profit', color: Colors.lightBlueAccent, num: 82),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                       Container(
//                         width: size.width,
//                         child: Wrap(
//                           spacing: 20,
//                           runSpacing: 20,
//                           alignment: WrapAlignment.start,
//                           children: [
//                             DashboardInfo3(icon: Icons.bar_chart,count: '4',description: 'Total Static Page',),
//                             DashboardInfo3(icon: Icons.bar_chart,count: '4',description: 'Total Static Page',),
//                             DashboardInfo3(icon: Icons.bar_chart,count: '4',description: 'Total Static Page',),
//                             DashboardInfo3(icon: Icons.bar_chart,count: '4',description: 'Total Static Page',),
//
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               MenuBox(),
//             ],
//           ),
//         );
//       })
//     );
//   }
// }
import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/column-scroll.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/bar-chart.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/bar-chart2.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/line-chart2.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/dashboard-box.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/dashboard-info.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/dashboard-info2.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/dashboard-info3.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/line-chart.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/main-pie-chart.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/pie-chart.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/main-bar-chart.dart';
import 'package:finance/UI/Componenets/Items/Header/header.dart';
import 'package:finance/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/UI/Componenets/accordion.dart';
import 'package:finance/UI/Componenets/alert.dart';
import 'package:finance/UI/Componenets/badge.dart';
import 'package:finance/UI/Componenets/breadCrumb.dart';
import 'package:finance/UI/Componenets/card.dart';
import 'package:finance/UI/Componenets/carousel-slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../Componenets/btn.dart';
import '../Componenets/dissmisiable-alert.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Obx((){
          return Container(
            width: size.width,
            color: MainController.isLightMode.value == false ? color6 :color9,
            child: Stack(
              children: [
                Header(),
                SizedBox(height: 20,),
                Positioned(
                  right: size.width > 800 ? MainController.isClickedItem.value == true ? 320 : 50 : 50,
                  top: 100,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: size.width > 800
                        ? MainController.isClickedItem.value == true
                        ? (size.width) - 350
                        : (size.width) - 50
                        : (size.width) - 50,
                    height: size.height,

                    child: ColumnScroll(
                      children: [
                        Container(
                          width: size.width,
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.start,
                            children: [
                              DashboardBox(icon: Icons.supervised_user_circle_outlined, count: 21, text: '${AppController.of(context)!.value('canceled orders')}', index: 0),
                              DashboardBox(icon: Icons.shield_moon_rounded, count: 0, text: '${AppController.of(context)!.value('unverified drivers')}', index: 1),
                              DashboardBox(icon: Icons.supervised_user_circle_sharp, count: 118, text: '${AppController.of(context)!.value('number of users')}', index: 2),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: MainController.isLightMode.value == true ? background : whiteColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Txt('${AppController.of(context)!.value('visit of the week')}',
                                color: MainController.isLightMode.value == true ? whiteColor : color1,
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 200,
                                width: size.width,
                                child: WeeklyChart(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          width: size.width,
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.start,
                            children: [
                              DashboardInfo(count: '72525' , description: 'No of Visits' , color: Colors.green , icon: Icons.supervised_user_circle,),
                              DashboardInfo(count: '11255' , description: 'Comments' , color: Colors.lightBlueAccent , icon: CupertinoIcons.chat_bubble_2_fill,),
                              DashboardInfo(count: '25550' , description: 'Salers' , color: Colors.orangeAccent , icon: CupertinoIcons.shopping_cart,),
                              DashboardInfo(count: '16150' , description: 'Daily Visits' , color: redColor , icon: CupertinoIcons.eye,),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          width: size.width,
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.start,
                            children: [
                              DashboardInfo2(title: 'Salers', color: Colors.yellow, num: 55),
                              DashboardInfo2(title: 'Customers', color: Colors.greenAccent, num: 84),
                              DashboardInfo2(title: 'No. of Visits', color: warningColor, num: 46),
                              DashboardInfo2(title: 'Profit', color: Colors.lightBlueAccent, num: 82),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          width: size.width,
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.start,
                            children: [
                              DashboardInfo3(icon: Icons.bar_chart,count: '4',description: 'Total Static Page',color: Colors.lightBlueAccent),
                              DashboardInfo3(icon: Icons.bar_chart,count: '15',description: 'Total Slider', color: CupertinoColors.systemOrange),
                              DashboardInfo3(icon: Icons.bar_chart,count: '70',description: 'Total Team',color: redColor),
                              DashboardInfo3(icon: Icons.bar_chart,count: '20',description: 'Total Services',color: Colors.green),
                              DashboardInfo3(icon: Icons.pie_chart_sharp,count: '30',description: 'Total Port',color: Colors.blueAccent),
                              DashboardInfo3(icon: Icons.supervised_user_circle,count: '50',description: 'Total User',color: Colors.pinkAccent),
                              DashboardInfo3(icon: Icons.supervised_user_circle,count: '65',description: 'Total Enquiries',color: Colors.green),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          width: size.width,
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              Container(
                                  height: 400,
                                  width: size.width > 996 ?  (size.width - 150) / 2 : size.width,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: shadow,
                                    color: whiteColor,
                                  ),
                                  child: LineChartSample1()),
                              Container(
                                  height: 400,
                                  width: size.width > 996 ? (size.width - 150) / 2 : size.width,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: shadow,
                                    color: whiteColor,
                                  ),
                                  child: BarChartSample()),
                              Container(
                                  height: 400,
                                  width: size.width > 996 ? (size.width - 150) / 2 : size.width,
                                  padding: EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: shadow,
                                    color: whiteColor,
                                  ),
                                  child: MainBarChart()),
                              Container(
                                  height: 400,
                                  width: size.width > 996 ? (size.width - 150) / 2 : size.width,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: shadow,
                                    color: whiteColor,
                                  ),
                                  child: MainPieChart()),
                            ],
                          ),
                        ),


                        //test component//
                        SizedBox(height: 30),
                        //acccordian
                        CustomAccordion(accordianTitle: 'item1' ,accordianTitleColor: redColor , accordianBoxColor: Colors.lightBlueAccent , accordianDescription: 'des1' , accordianDescriptionColor: Colors.black , colorIcon: color20 , colorBoxDescription: Colors.black26),
                        CustomAccordion(accordianTitle: 'item2' ,accordianTitleColor: Colors.blue , accordianBoxColor: Colors.white , accordianDescription: 'des2' , accordianDescriptionColor: Colors.yellow , colorIcon: color20 , colorBoxDescription: Colors.pink),
                        SizedBox(height: 30),
                        //alert
                        InkWell(
                          onTap: (){
                            // showCustomAnimatedAlert(context ,
                            //   'errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr' ,
                            //   Colors.black,purpleColor, CupertinoColors.extraLightBackgroundGray,
                            //   linkText: 'اینجا',
                            //   onLinkTap: () {
                            //     print('لینک کلیک شد');
                            //   },
                            // );
                            showCustomAnimatedAlert(
                              context,
                              '',
                              Colors.black,
                              Colors.white,
                              Colors.blue,
                              textSegments: [
                                TextSegment(text: 'شرایط '),
                                TextSegment(
                                  text: 'حریم خصوصی',
                                  isLink: true,
                                  color: Colors.red,
                                  onTap: () => print('حریم خصوصی'),
                                ),
                                TextSegment(text: ' و '),
                                TextSegment(
                                  text: 'قوانین',
                                  isLink: true,
                                  color: Colors.green,
                                  onTap: () => print('قوانین'),
                                ),
                                TextSegment(text: ' را مطالعه کنید.'),
                              ],
                            );
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.red,
                            child: Center(child: Txt('click' , color: Colors.white,)),
                          ),
                        ),
                        SizedBox(height: 30),
                        //dismissible-alert
                        DismissibleAlert(
                          message: 'این یک پیام تست است',
                          type: AlertType.warning,
                          alignment: Alignment.centerRight,
                        ),
                        SizedBox(height: 30),
                        DismissibleAlert(
                          message: 'این یک پیام تست است',
                          type: AlertType.success,
                        ),
                        SizedBox(height: 30),
                        DismissibleAlert(
                          message: 'این یک پیام تست است',
                          type: AlertType.error,
                        ),
                        SizedBox(height: 30),
                        //badge
                        // AdvancedBadge(
                        //   color: Colors.grey,
                        //   textColor: Colors.white,
                        //   child: Icon(Icons.notifications, size: 30),
                        //   text: '3',
                        //   shape: BadgeShape.rectangular,
                        //   size: 14,
                        // ),
                        // AdvancedBadge(
                        //   child: Text('سبد خرید', style: TextStyle(color: Colors.blue)),
                        //   text: '5',
                        //   isInteractive: true,
                        //   shape: BadgeShape.rectangular,
                        //   onTap: () {
                        //
                        //   },
                        // )

                        //Breadcrumb
                        Breadcrumb(
                          itemClickedColor: Colors.blue,
                          itemColor: Colors.red,
                          items: [
                            BreadcrumbItem(
                                label: 'خانه',
                                onPressed: (){}
                            ),
                            BreadcrumbItem(
                              label: 'محصولات',
                            ),
                            BreadcrumbItem(
                              label: 'الکترونیک',
                            ),
                            BreadcrumbItem(
                              label: 'گوشی موبایل',
                            ),
                          ],
                        ),

                        //btn
                        Btn(btnType.custom,color: Colors.blue , text: 'primary', hoverColor: Colors.blueAccent, isBlock: true),
                        SizedBox(height: 30),
                        Btn(btnType.primary,color: Colors.green , text: 'primary2', hoverColor: Colors.greenAccent, ),
                        // LayoutBuilder(
                        //   builder: (context, constraints) {
                        //     final bool isVertical = constraints.maxWidth < 768;
                        //     return isVertical
                        //         ? Column(
                        //       children: [
                        //         Btn(btnType.primary, text: "دکمه ۱", color: Colors.blue ,),
                        //         SizedBox(height: 8),
                        //         Btn(btnType.primary, text: "دکمه ۲", color: Colors.blue ,),
                        //       ],
                        //     )
                        //         : Row(
                        //       children: [
                        //         Btn(btnType.primary, text: "دکمه ۱", color: Colors.blue ,),
                        //         SizedBox(width: 8),
                        //         Btn(btnType.primary, text: "دکمه ۲", color: Colors.blue ,),
                        //       ],
                        //     );
                        //   },
                        // )
                        SizedBox(height: 30),
                        Btn(btnType.primary,color: Colors.green , text: 'primary3', hoverColor: Colors.greenAccent,isToggle: true),
                        SizedBox(height: 30),
                        Btn(btnType.primary,color: Colors.green , text: 'primary4', hoverColor: Colors.greenAccent,isToggle: true , isLink: true),
                        SizedBox(height: 30),
                        Btn(btnType.primary,color: Colors.green , text: 'primary5', hoverColor: Colors.greenAccent,size: ButtonSize.small,),
                        SizedBox(height: 30),
                        Btn(btnType.primary,color: Colors.green , text: 'd-md-block', hoverColor: Colors.greenAccent,responsive: true,),
                        SizedBox(height: 30),
                        Btn(btnType.primary,color: Colors.green , text: 'col-6 mx-auto', hoverColor: Colors.greenAccent, responsive: true,gridColumns: 6, centerHorizontal: true, ),


                        SizedBox(height: 30),
                        //badge
                        CustomBadge(
                          child:  Icon(Icons.shopping_cart, size: 30),
                          value: '3',
                          color: Colors.blue,
                          size: 10,
                          colorText: Colors.black,
                          right: -2,
                          top: -20,
                        ),
                        SizedBox(height: 30),
                        //card
                        // CustomCard(
                        //   elevation: 4,
                        //   borderRadius: 12,
                        //   borderColor: Color.fromRGBO(0, 0, 0, 0.175),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Icon(Icons.star, size: 40),
                        //       SizedBox(height: 10),
                        //       Text('کارت سفارشی', style: TextStyle(fontWeight: FontWeight.bold)),
                        //     ],
                        //   ),
                        // )
                        //carousel slider

                        //carousel slider
                        MyCarousel(imageUrls: [
                          'https://images.unsplash.com/photo-1506744038136-46273834b3fb', // تصویر کوهستان
                          'https://images.unsplash.com/photo-1472214103451-9374bd1c798e', // تصویر آبشار
                          'https://images.unsplash.com/photo-1433086966358-54859d0ed716'  // تصویر جنگل
                        ]),
                        SizedBox(height: 30),
                        MyCarousel(imageUrls: [
                          'https://images.unsplash.com/photo-1506744038136-46273834b3fb', // تصویر کوهستان
                          'https://images.unsplash.com/photo-1472214103451-9374bd1c798e', // تصویر آبشار
                          'https://images.unsplash.com/photo-1433086966358-54859d0ed716'  // تصویر جنگل
                        ],showIndicators: true),
                        SizedBox(height: 30),
                        MyCarousel(imageUrls: [
                          'https://images.unsplash.com/photo-1506744038136-46273834b3fb', // تصویر کوهستان
                          'https://images.unsplash.com/photo-1472214103451-9374bd1c798e', // تصویر آبشار
                          'https://images.unsplash.com/photo-1433086966358-54859d0ed716'  // تصویر جنگل
                        ],showIndicators: true , isCaption: true , captions: [
                          Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
                          Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
                          Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
                        ],),


                      ],
                    ),
                  ),
                ),
                MenuBox(),
              ],
            ),
          );
        })
    );
  }
}
