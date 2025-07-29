import 'package:panel/Admin/Logic/Controllers/app-controller.dart';
import 'package:panel/Admin/Logic/Controllers/main-controller.dart';
import 'package:panel/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:panel/Admin/UI/Componenets/Items/Dashboard/bar-chart.dart';
import 'package:panel/Admin/UI/Componenets/Items/Dashboard/dashboard-info.dart';
import 'package:panel/Admin/UI/Componenets/Items/Dashboard/dashboard-info2.dart';
import 'package:panel/Admin/UI/Componenets/Items/Dashboard/dashboard-info3.dart';
import 'package:panel/Admin/UI/Componenets/Items/Dashboard/line-chart.dart';
import 'package:panel/Admin/UI/Componenets/Items/Dashboard/line-chart2.dart';
import 'package:panel/Admin/UI/Componenets/Items/Dashboard/main-bar-chart.dart';
import 'package:panel/Admin/UI/Componenets/Items/Dashboard/main-pie-chart.dart';
import 'package:panel/Admin/UI/Views/dashboard.dart';
import 'package:panel/Admin/UI/Views/test-component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Public/styles.dart';
class ComponentPage extends StatelessWidget {
  const ComponentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: MainController.isLightMode.value == false ? color6 :color9,
        child: ColumnScroll(
          children: [
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (){
                    Get.to(() => DashboardPage());
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: colorBtn,
                    ),
                    child: Center(child: Txt('${AppController.of(context)!.value('back')}' , color: whiteColor,)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Column(
              children: [
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
                TestComponent(),
              ],
            ),
          ],
        ),
      )
    );
  }
}
