import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Public/images.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/column-scroll.dart';
import 'package:finance/UI/Componenets/General/img.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/bar-chart.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/line-chart2.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/dashboard-box.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/dashboard-info.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/dashboard-info2.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/dashboard-info3.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/line-chart.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/main-pie-chart.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/main-bar-chart.dart';
import 'package:finance/UI/Componenets/Items/Header/header.dart';
import 'package:finance/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/UI/Componenets/accordion.dart';
import 'package:finance/UI/Componenets/alert.dart';
import 'package:finance/UI/Componenets/badge.dart';
import 'package:finance/UI/Componenets/breadCrumb.dart';
import 'package:finance/UI/Componenets/card.dart';
import 'package:finance/UI/Componenets/carousel-slider.dart';
import 'package:finance/UI/Componenets/close-btn.dart';
import 'package:finance/UI/Componenets/collapse.dart';
import 'package:finance/UI/Componenets/drop-down.dart';
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
                        Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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


                          //carousels
                          //basic
                          MyCarousel(items: [
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1472214103451-9374bd1c798e',
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1433086966358-54859d0ed716',
                            ),
                          ]),
                          SizedBox(height: 30),
                          //Indicators
                          MyCarousel(items: [
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1472214103451-9374bd1c798e',
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1433086966358-54859d0ed716',
                            ),
                          ],showIndicators: true),
                          SizedBox(height: 30),
                          //Captions
                          MyCarousel(items: [
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                              caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1472214103451-9374bd1c798e',
                              caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1433086966358-54859d0ed716',
                              caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
                            ),
                          ],showIndicators: true , hasCaption: true),
                          SizedBox(height: 30),
                          //Autoplaying
                          MyCarousel(items: [
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                              caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1472214103451-9374bd1c798e',
                              caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1433086966358-54859d0ed716',
                              caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
                            ),
                          ],showIndicators: true , hasCaption: true , isAutoPlay: true),
                          SizedBox(height: 30),
                          //ride
                          MyCarousel(items: [
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                              caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1472214103451-9374bd1c798e',
                              caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1433086966358-54859d0ed716',
                              caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
                            ),
                          ],showIndicators: true , hasCaption: true ,ride: true),
                          SizedBox(height: 30),
                          //Individual .carousel-item interval
                          MyCarousel(items: [
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                              caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
                              autoPlayInterval: Duration(seconds: 10),
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1472214103451-9374bd1c798e',
                              caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
                              autoPlayInterval: Duration(seconds: 20),
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1433086966358-54859d0ed716',
                              caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
                              autoPlayInterval: Duration(seconds: 40),
                            ),
                          ],showIndicators: true , hasCaption: true , isAutoPlay: true),
                          SizedBox(height: 30),
                          //Autoplaying carousels without controls
                          MyCarousel(items: [
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                              caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),

                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1472214103451-9374bd1c798e',
                              caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),

                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1433086966358-54859d0ed716',
                              caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
                            ),
                          ],showIndicators: true , hasCaption: true , isAutoPlay: true , hasControl: true),
                          SizedBox(height: 30),
                          //Disable touch swiping
                          MyCarousel(items: [
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                              caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1472214103451-9374bd1c798e',
                              caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1433086966358-54859d0ed716',
                              caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
                            ),
                          ],showIndicators: true , hasCaption: true , isAutoPlay: true ,hasTouchSwipping: false),
                          SizedBox(height: 30),
                          //Dark variant
                          MyCarousel(items: [
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                              caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1472214103451-9374bd1c798e',
                              caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1433086966358-54859d0ed716',
                              caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
                            ),
                          ],showIndicators: true , hasCaption: true , colorBox: color25,colorIcon: color26,colorIndicator: color26,colorIndicatorActive: blackColor,colorTxt: blackColor, isAutoPlay: true),
                          SizedBox(height: 30),
                          //Crossfade
                          MyCarousel(items: [
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                              caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1472214103451-9374bd1c798e',
                              caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
                            ),
                            CarouselItem(
                              imageUrl:  'https://images.unsplash.com/photo-1433086966358-54859d0ed716',
                              caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
                            ),
                          ],showIndicators: true , hasCaption: true , isAutoPlay: true  , isCrossFade: true),



                          //card
                          SizedBox(height: 30),
                          CustomCard(
                            title: 'aaaaaaaaaaaaaaaaaaaaaaabbbb',
                            description: 'bbbbbbbbb',
                            titleColor: blackColor,
                            desriptionColor: Colors.red,
                            imageTop: Img(loginSvg),
                            btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, text: 'dddddddddddddd', ),
                          ),
                          SizedBox(height: 30),
                          //Titles, text, and links
                          CustomCard(
                            title: 'Card title',
                            subTitle: 'Card subtitle',
                            subTitleColor: Colors.pink,
                            description: 'Some quick example text to build on the card title and make up the bulk of the card',
                            titleColor: blackColor,
                            desriptionColor: Colors.red,
                            links: [
                              CardLink(text: 'Card link' , onTap: (){}),
                              CardLink(text: 'Another link' , onTap: (){})
                            ],
                          ),
                          SizedBox(height: 30),
                          //Images
                          CustomCard(
                            description: 'Some quick example text to build on the card title and make up the bulk of ',
                            titleColor: blackColor,
                            desriptionColor: Colors.red,
                            imageTop: Img(loginSvg),
                          ),
                          SizedBox(height: 30),
                          //List groups
                          CustomCard(
                            listItems: [
                              'An item',
                              'A second item',
                              'A third item'
                            ],
                          ),
                          SizedBox(height: 30),
                          //List groups card-header
                          CustomCard(
                            cardHeader: 'Featured',
                            headerOrFooterBackgroundColor: Colors.red,
                            cardHeaderOrFooterColor: darkBackground,
                            listItemColor: color1,
                            listItems: [
                              'An item',
                              'A second item',
                              'A third item'
                            ],
                          ),
                          SizedBox(height: 30),
                          //List groups card-footer
                          CustomCard(
                            cardFooter: 'Card footer',
                            headerOrFooterBackgroundColor: Colors.red,
                            cardHeaderOrFooterColor: darkBackground,
                            listItemColor: color1,
                            listItems: [
                              'An item',
                              'A second item',
                              'A third item'
                            ],
                          ),
                          SizedBox(height: 30),
                          //Kitchen sink
                          CustomCard(
                            imageTop: Img(loginSvg),
                            title: 'Card title',
                            description: 'Some quick example text to build on the card title and make up the bulk of the card',
                            titleColor: darkBackground,
                            desriptionColor: darkBackground,
                            links: [
                              CardLink(text: 'Card link' , onTap: (){}),
                              CardLink(text: 'Another link' , onTap: (){})
                            ],
                            listItems: [
                              'An item',
                              'A second item',
                              'A third item'
                            ],
                          ),
                          SizedBox(height: 30),
                          //Header and footer
                          CustomCard(
                            cardHeader: 'Featured',
                            cardHeaderOrFooterColor: darkBackground,
                            headerOrFooterBackgroundColor: Colors.red,
                            title: 'Special title treatment',
                            description: 'With supporting text below as a natural lead-in to additional content.',
                            titleColor: darkBackground,
                            desriptionColor: darkBackground,
                            btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, text: 'dddddddddddddd', ),
                          ),
                          SizedBox(height: 30),
                          //center
                          CustomCard(
                            cardHeader: 'Featured',
                            cardHeaderOrFooterColor: darkBackground,
                            headerOrFooterBackgroundColor: Colors.red,
                            title: 'Special title treatment',
                            description: 'With supporting text below as a natural lead-in to additional content.',
                            titleColor: darkBackground,
                            desriptionColor: darkBackground,
                            btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, text: 'dddddddddddddd', ),
                            cardFooter:'2 days ago',
                            isCenter: true,
                          ),
                          SizedBox(height: 30),
                          //Sizing
                          //Using grid markup
                          Container(
                            width: size.width,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              alignment: WrapAlignment.start,
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                CustomCard(
                                  title: 'Special title treatment',
                                  description: 'With supporting text below as a natural lead-in to additional content.',
                                  titleColor: darkBackground,
                                  desriptionColor: darkBackground,
                                  btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, text: 'dddddddddddddd', ),
                                  width: (size.width / 2) - 32,
                                  margin: EdgeInsets.only(bottom: 16),
                                  isChangedWidthResponsive: true,
                                ),
                                // SizedBox(width: 10,),
                                CustomCard(
                                  title: 'Special title treatment',
                                  description: 'With supporting text below as a natural lead-in to additional content.',
                                  titleColor: darkBackground,
                                  desriptionColor: darkBackground,
                                  btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, text: 'dddddddddddddd', ),
                                  width:(size.width / 2 )- 32,
                                  isChangedWidthResponsive: true,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          //Using utilities
                          Container(
                            width: size.width,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              alignment: WrapAlignment.start,
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                CustomCard(
                                  title: 'Special title treatment',
                                  description: 'With supporting text below as a natural lead-in to additional content.',
                                  titleColor: darkBackground,
                                  desriptionColor: darkBackground,
                                  btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, text: 'dddddddddddddd', ),
                                  width: (size.width * 0.75) - 32,
                                  margin: EdgeInsets.only(bottom: 16),
                                ),
                                // SizedBox(width: 10,),
                                CustomCard(
                                  title: 'Special title treatment',
                                  description: 'With supporting text below as a natural lead-in to additional content.',
                                  titleColor: darkBackground,
                                  desriptionColor: darkBackground,
                                  btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, text: 'dddddddddddddd', ),
                                  width:(size.width * 0.25 )- 32,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          //Using custom CSS
                          CustomCard(
                            title: 'Special title treatment',
                            description: 'With supporting text below as a natural lead-in to additional content.',
                            titleColor: darkBackground,
                            desriptionColor: darkBackground,
                            btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, text: 'dddddddddddddd', ),
                            width: 300,
                          ),
                          SizedBox(height: 30),
                          //blockquote
                          CustomCard(
                            title: 'Special title treatment',
                            titleColor: darkBackground,
                            blockquote: 'Someone famous in ',
                          ),
                          SizedBox(height: 30),
                          //<h*>
                          CustomCard(
                            title: 'Special title treatment',
                            titleColor: darkBackground,
                            cardHeader: 'Featured',
                            cardHeaderOrFooterColor: darkBackground,
                            headerOrFooterBackgroundColor: Colors.red,
                            description: 'With supporting text below as a natural lead-in to additional content.',
                            desriptionColor: darkBackground,
                            isChangeFontWeigth: true,

                          ),
                          SizedBox(height: 30),
                          //Text alignment
                          //start
                          CustomCard(
                            title: 'Special title treatment start',
                            description: 'With supporting text below as a natural lead-in to additional content.',
                            titleColor: darkBackground,
                            desriptionColor: darkBackground,
                            btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, text: 'dddddddddddddd', ),
                            width: 500,
                          ),
                          SizedBox(height: 30),
                          //center
                          CustomCard(
                            title: 'Special title treatment center',
                            description: 'With supporting text below as a natural lead-in to additional content.',
                            titleColor: darkBackground,
                            desriptionColor: darkBackground,
                            btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, text: 'dddddddddddddd', ),
                            width: 500,
                            isCenter: true,
                          ),
                          SizedBox(height: 30),
                          //end
                          CustomCard(
                            title: 'Special title treatment end',
                            description: 'With supporting text below as a natural lead-in to additional content.',
                            titleColor: darkBackground,
                            desriptionColor: darkBackground,
                            btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, text: 'dddddddddddddd', ),
                            width: 500,
                            isEnd: true,
                          ),
                          //Navigation

                          SizedBox(height: 30),
                          //Image caps
                          //image-top
                          CustomCard(
                            title: 'Card title',
                            description: 'Some quick example text to build on the card title and make up the bulk of ',
                            titleColor: blackColor,
                            desriptionColor: Colors.red,
                            imageTop: Img(loginSvg),
                          ),
                          SizedBox(height: 30),
                          //image-bottom
                          CustomCard(
                            title: 'Card title',
                            description: 'Some quick example text to build on the card title and make up the bulk of ',
                            titleColor: blackColor,
                            desriptionColor: Colors.red,
                            imageBottom: Img(loginSvg),
                          ),
                          SizedBox(height: 30),
                          //image-overlay
                          CustomCard(
                            borderColorBox: blackColor,
                            title: 'Card title',
                            description: 'Some quick example text to build on the card title and make up the bulk of ',
                            titleColor: blackColor,
                            desriptionColor: whiteColor,
                            overlayContent: true,
                            imgUrl: test,
                          ),
                          SizedBox(height: 30),
                          //Horizontal
                          CustomCard(
                            title: 'Card title',
                            description: 'Some quick example text to build on the card title and make up the bulk of ',
                            titleColor: blackColor,
                            desriptionColor: Colors.red,
                            imageRight: Img(loginSvg ,height: 200,),
                            width: 600,
                            isHorizental: true,
                            flexRight: 2,
                            flexLeft: 3,
                          ),
                          SizedBox(height: 30),
                          //Background and color
                          CustomCard(
                            borderColorBox: Colors.blue,
                            cardFooter: 'Header',
                            cardHeaderOrFooterColor: blackColor,
                            headerOrFooterBackgroundColor:Colors.greenAccent,
                            borderColor: Colors.yellow,
                            title: 'aaaaaaaaaaaaaaaaaaaaaaabbbb',
                            description: 'bbbbbbbbb',
                            titleColor: blackColor,
                            desriptionColor: blackColor,
                            width: 300,
                          ),
                          SizedBox(height: 30),
                          //Card groups
                          Wrap(
                            children: [
                              CustomCard(
                                borderColorBox: Colors.blue,
                                cardFooter: 'Header',
                                cardHeaderOrFooterColor: blackColor,
                                headerOrFooterBackgroundColor:Colors.greenAccent,
                                borderColor: Colors.yellow,
                                title: 'Card title',
                                description: 'This card has supporting text below as a natural lead-in to additional content.',
                                titleColor: blackColor,
                                desriptionColor: blackColor,
                                width: 300,
                                isEqualHeight: true,
                                height: 300,
                              ),
                              CustomCard(
                                borderColorBox: Colors.blue,
                                cardFooter: 'Header',
                                cardHeaderOrFooterColor: blackColor,
                                headerOrFooterBackgroundColor:Colors.greenAccent,
                                borderColor: Colors.yellow,
                                title: 'Card title',
                                description: 'This is a wider card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.',
                                titleColor: blackColor,
                                desriptionColor: blackColor,
                                width: 300,
                                isEqualHeight: true,
                                height: 300,
                              ),
                              CustomCard(
                                borderColorBox: Colors.blue,
                                cardFooter: 'Header',
                                cardHeaderOrFooterColor: blackColor,
                                headerOrFooterBackgroundColor:Colors.greenAccent,
                                borderColor: Colors.yellow,
                                title: 'Card title',
                                description: 'This is a wider card with supporting text below as a natural lead-in to additional content. This card has even longer content than the first to show that equal height action.',
                                titleColor: blackColor,
                                desriptionColor: blackColor,
                                width: 300,
                                isEqualHeight: true,
                                height: 300,
                              ),
                            ],
                          ),


                          //Close button
                          //basic
                          CloseBtn(onClose: (){
                            print('click close btn');
                          }),
                          SizedBox(height: 10),
                          //Disabled state
                          CloseBtn(onClose: (){
                            print('click close btn');
                          } , isDisabled: true),
                          SizedBox(height: 10),
                          //Dark variant
                          CloseBtn(onClose: (){
                            print('click close btn');
                          } , isDark: true,),


                          SizedBox(height: 30),
                          //Collapse
                          Collapse(btnTxt: 'Link with href' , content: 'Some placeholder content for the collapse component. This panel is hidden by default but revealed when the user activates the relevant trigger.',),
                          SizedBox(height: 10),
                          Collapse(btnTxt: 'Link with href' , content: 'Some placeholder content for the collapse component. This panel is hidden by default but revealed when the user activates the relevant trigger.', isHorizontal: true),
                          SizedBox(height: 10),
                          MultiCollapse(
                            buttons: [
                              Collapse(
                                btnTxt: "Toggle first element",
                                targetId: "collapse1",
                              ),
                              Collapse(
                                btnTxt: "Toggle second element",
                                targetId: "collapse2",
                              ),
                              Collapse(
                                btnTxt: "Toggle both elements",
                                targetIds: ["collapse1", "collapse2"],
                              ),
                            ],
                            collapsibles: [
                              Collapse(
                                targetId: "collapse1",
                                content: "Content for first collapse",
                              ),
                              Collapse(
                                targetId: "collapse2",
                                content: "Content for second collapse",
                              ),
                            ],
                          ),

                          SizedBox(height: 60,),
                          //dropDown
                          //Single button
                          Dropdown(dropDownTitle: 'Dropdown button' ,
                              itemsDropDown: [
                                DropdownItem(text: "Action"),
                                DropdownItem(text: "Another action"),
                                DropdownItem(text: "Something else here"),],),
                          SizedBox(height: 40,),
                          //Split button
                          Dropdown(dropDownTitle: 'Dropdown Split button' ,
                             itemsDropDown: [
                               DropdownItem(text: "Action"),
                               DropdownItem(text: "Another action"),
                               DropdownItem(text: "Something else here"),
                             ],
                            isSplitButton: true,),
                          SizedBox(height: 40,),
                          //spreadLink
                          Dropdown(dropDownTitle: 'Dropdown button' , itemsDropDown: [
                            DropdownItem(text: "Action"),
                            DropdownItem(text: "Another action"),
                            DropdownItem(text: "Something else here"),
                          ],spreadLinkList:['spread link']),
                          SizedBox(height: 40,),
                          //Sizing
                          //large
                          Dropdown(dropDownTitle: 'Large button' , itemsDropDown: [
                            DropdownItem(text: "Action"),
                            DropdownItem(text: "Another action"),
                            DropdownItem(text: "Something else here"),],spreadLinkList:['spread link'], size: DropDownSize.large),
                          SizedBox(height: 40,),
                          //small
                          Dropdown(dropDownTitle: 'Small button' , itemsDropDown: [
                            DropdownItem(text: "Action"),
                            DropdownItem(text: "Another action"),
                            DropdownItem(text: "Something else here"),],spreadLinkList:['spread link'] , size: DropDownSize.small),
                          SizedBox(height: 40,),
                          //Dark dropdowns
                          Dropdown(dropDownTitle: 'dark button' , itemsDropDown: [
                            DropdownItem(text: "Action"),
                            DropdownItem(text: "Another action"),
                            DropdownItem(text: "Something else here"),
                          ],spreadLinkList:['spread link'] , ColorDropDownBox: color34 , ColorTitleDropDownBox: color5, showActiveSelectItem: true,),
                          SizedBox(height: 40,),
                          //Directions
                          //up
                          Dropdown(dropDownTitle: 'DropUp' , direction: directions.up,itemsDropDown: [
                            DropdownItem(text: "Action"),
                            DropdownItem(text: "Another action"),
                            DropdownItem(text: "Something else here"),],spreadLinkList:['spread link']),
                          SizedBox(height: 40,),
                          //end
                          Dropdown(dropDownTitle: 'Drop end' , direction: directions.end,itemsDropDown: [
                            DropdownItem(text: "Action"),
                            DropdownItem(text: "Another action"),
                            DropdownItem(text: "Something else here"),],spreadLinkList:['spread link']),
                          SizedBox(height: 40,),
                          //start
                          Dropdown(dropDownTitle: 'Drop start' , direction: directions.start,itemsDropDown: [
                            DropdownItem(text: "Action"),
                            DropdownItem(text: "Another action"),
                            DropdownItem(text: "Something else here"),
                          ],spreadLinkList:['spread link']),
                          SizedBox(height: 40,),
                          //dropDownItemText
                          Dropdown(
                            itemsDropDown: [
                              DropdownItem(text: "Dropdown item text", isInteractive: false),
                              DropdownItem(text: "Action", value: "action"),
                              DropdownItem(text: "Another action", value: "another_action"),
                              DropdownItem(text: "Something else here", value: "something_else"),
                            ], dropDownTitle: 'dropDownItemText',
                          ),
                          SizedBox(height: 40,),
                          //active
                          Dropdown(
                            itemsDropDown: [
                              DropdownItem(text: "Dropdown item text"),
                              DropdownItem(text: "Action", value: "action"),
                              DropdownItem(text: "Another action", value: "another_action" , isActive: true),
                              DropdownItem(text: "Something else here", value: "something_else"),
                            ], dropDownTitle: 'active item',
                          ),
                          SizedBox(height: 40,),
                          //Disabled
                          Dropdown(
                            itemsDropDown: [
                              DropdownItem(text: "Dropdown item text"),
                              DropdownItem(text: "Action", value: "action"),
                              DropdownItem(text: "Another action", value: "another_action", isDisabled: true),
                              DropdownItem(text: "Something else here", value: "something_else"),
                            ], dropDownTitle: 'disabled item',
                          ),
                          SizedBox(height: 40,),
                          //Menu alignment
                          //left
                         Container(
                           width: size.width,
                           color: Colors.red,
                           child: Center(
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                                 Dropdown(
                                   itemsDropDown: [
                                     DropdownItem(text: "Dropdown item text"),
                                     DropdownItem(text: "Action", value: "action"),
                                     DropdownItem(text: "Another action", value: "another_action"),
                                     DropdownItem(text: "Something else here", value: "something_else"),
                                   ], dropDownTitle: 'left align menu', direction: directions.left,
                                 ),
                                 SizedBox(height: 10,),
                                 //right
                                 Dropdown(
                                   itemsDropDown: [
                                     DropdownItem(text: "Dropdown item text"),
                                     DropdownItem(text: "Action", value: "action"),
                                     DropdownItem(text: "Another action", value: "another_action"),
                                     DropdownItem(text: "Something else here", value: "something_else"),
                                   ], dropDownTitle: 'right align menu', direction: directions.right,
                                 ),
                               ],
                             ),
                           ),
                         ),
                          SizedBox(height:40),
                          //header
                          Dropdown(
                              itemsDropDown: [
                                DropdownItem(text: "Dropdown item text", isHeader: true ),
                                DropdownItem(text: "Action", value: "action"),
                                DropdownItem(text: "Another action", value: "another_action"),
                                DropdownItem(text: "Something else here", value: "something_else"),
                              ], dropDownTitle: 'Headers item',
                            ),
                          SizedBox(height:40),
                          //Forms
                          Dropdown(
                            hasForm: true,
                            dropDownTitle: 'DropDown Form',
                          ),

                        ],
                      ),]
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
