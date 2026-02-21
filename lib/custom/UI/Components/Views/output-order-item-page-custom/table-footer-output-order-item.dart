import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';

// class TableFooterOutPutOrderItem extends StatefulWidget {
//   const TableFooterOutPutOrderItem({Key? key}) : super(key: key);
//
//   @override
//   State<TableFooterOutPutOrderItem> createState() => _TableFooterOutPutOrderItemState();
// }
//
// class _TableFooterOutPutOrderItemState extends State<TableFooterOutPutOrderItem> {
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//
//     return Obx((){
//       return Container(
//         child: size.width > 556 ?
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: pagenationBox(ViewCustomController.getTotalPage().obs),
//         ) :
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: pagenationBox(ViewCustomController.getTotalPage().obs),
//         ),);
//     });
//   }
//   Widget box(int i){
//     Rx<bool> isHover = false.obs;
//     return MouseRegion(
//       onEnter: (_){
//         isHover.value = true;
//       },
//       onExit: (_){
//         isHover.value = false;
//       },
//       child: InkWell(
//         onTap: ()async{
//           setState(() {
//             ViewCustomController.OrderItemOutPutCurrentPage.value = i;
//           });
//           // ViewCustomController.paginate();
//           ViewCustomController.filteredData.value = ViewCustomController.paginate();
//         },
//         child: Container(
//             margin: EdgeInsets.only(right: Directionality.of(context) == TextDirection.ltr ? 5  : 0 , left:Directionality.of(context) == TextDirection.rtl ? 5  : 0  ),
//             width: 40,
//             height: 40,
//             child: Obx((){
//               return Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color:isHover.value == true  ? colorBtn:i == ViewCustomController.OrderItemOutPutCurrentPage.value ? colorBtn : Colors.blue,
//                 ),
//                 child: Center(child: Txt('${i}', textAlign: TextAlign.center , color: whiteColor,)),
//               );
//             })
//         ),
//       ),
//     );
//   }
//
//   List<Widget> pagenationBox(RxInt totalPages){
//     var size = MediaQuery.of(context).size;
//     return [
//       size.width > 556 ?
//       Expanded(child: Wrap(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(
//                   Radius.circular(5)),
//               color: ViewCustomController.OrderItemOutPutCurrentPage.value> 1
//                   ? color3
//                   : color7,
//             ),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.all(15)),
//               onPressed: ViewCustomController.OrderItemOutPutCurrentPage.value > 1 ? () async {
//                 setState(() {
//                   ViewCustomController.OrderItemOutPutCurrentPage.value--;
//                 });
//                 // MainController.dataRecord.value= await DB('${tableSelected}').paginate();
//                 // ViewCustomController.paginate();
//                 ViewCustomController.filteredData.value = ViewCustomController.paginate();
//               } : null,
//               child: Txt('${AppController.of(context)!.value(
//                   'previous')}', color: ViewCustomController.OrderItemOutPutCurrentPage.value > 1
//                   ? whiteColor
//                   : color3),
//             ),
//           ),
//           SizedBox(width: 5,),
//           if (totalPages > 5) ...[
//             box(1),
//             box(2),
//             SizedBox(width: 5),
//             Container(
//               margin: EdgeInsets.only(right: Directionality.of(context) == TextDirection.ltr ? 5  : 0 , left:Directionality.of(context) == TextDirection.rtl ? 5  : 0  ),
//               width: 40,
//               height: 40,
//               child: Center(child: Txt('...', fontSize: 20)),
//             ),
//             SizedBox(width: 5),
//             box(totalPages.value - 1),
//             box(totalPages.value),
//           ] else ...[
//             for (var i = 1; i <= totalPages.value; i++)
//               box(i),
//           ],
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(
//                   Radius.circular(5)),
//               color: ViewCustomController.OrderItemOutPutCurrentPage.value <
//                   totalPages.value
//                   ? color3
//                   : color7,
//             ),
//             child: Container(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.all(15)),
//                 onPressed: ViewCustomController.OrderItemOutPutCurrentPage.value <
//                     totalPages.value ? () async {
//                   setState(() {
//                     ViewCustomController.OrderItemOutPutCurrentPage.value++;
//                   });
//                   // MainController.dataRecord.value= await DB('${tableSelected}').paginate();
//                   // ViewCustomController.paginate();
//                   ViewCustomController.filteredData.value = ViewCustomController.paginate();
//
//                 } : null,
//                 child: Txt(
//                   '${AppController.of(context)!.value('next')}',
//                   color: ViewCustomController.OrderItemOutPutCurrentPage.value <
//                       totalPages.value
//                       ? whiteColor
//                       : color3,),
//               ),
//             ),
//           ),
//         ],
//       )):
//       Container(
//         padding: EdgeInsets.only(left: 40, right: 40),
//         child: Wrap(
//           children: <Widget>[
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(
//                     Radius.circular(5)),
//                 color: ViewCustomController.OrderItemOutPutCurrentPage.value > 1
//                     ? color3
//                     : color7,
//               ),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.all(15)),
//                 onPressed: ViewCustomController.OrderItemOutPutCurrentPage.value > 1 ? () async {
//                   setState(() {
//                     ViewCustomController.OrderItemOutPutCurrentPage.value--;
//                   });
//                   // MainController.renderPagination();
//                   // MainController.dataRecord.value= await DB('${tableSelected}').paginate();
//                   // ViewCustomController.paginate();
//                   ViewCustomController.filteredData.value = ViewCustomController.paginate();
//                 } : null,
//                 child: Txt('${AppController.of(context)!.value(
//                     'previous')}', color: ViewCustomController.OrderItemOutPutCurrentPage.value > 1
//                     ? whiteColor
//                     : color3),
//               ),
//             ),
//             SizedBox(width: 5,),
//             if (totalPages > 5) ...[
//               box(1),
//               box(2),
//               SizedBox(width: 5),
//               Container(
//                 margin: EdgeInsets.only(right: Directionality.of(context) == TextDirection.ltr ? 5  : 0 , left:Directionality.of(context) == TextDirection.rtl ? 5  : 0  ),
//                 width: 40,
//                 height: 40,
//                 child: Center(child: Txt('...', fontSize: 20)),
//               ),
//               SizedBox(width: 5),
//               box(totalPages.value - 1),
//               box(totalPages.value),
//             ] else ...[
//               for (var i = 1; i <= totalPages.value; i++)
//                 box(i),
//             ],
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(
//                     Radius.circular(5)),
//                 color: ViewCustomController.OrderItemOutPutCurrentPage.value <
//                     totalPages.value
//                     ? color3
//                     : color7,
//               ),
//               child: Container(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.all(15)),
//                   onPressed: ViewCustomController.OrderItemOutPutCurrentPage.value <
//                       totalPages.value ? () async {
//                     setState(() {
//                       ViewCustomController.OrderItemOutPutCurrentPage.value++;
//                     });
//                     // MainController.renderPagination();
//                     // MainController.dataRecord.value= await DB('${tableSelected}').paginate();
//                     // ViewCustomController.paginate();
//                     ViewCustomController.filteredData.value = ViewCustomController.paginate();
//
//                   } : null,
//                   child: Txt(
//                     '${AppController.of(context)!.value('next')}',
//                     color: ViewCustomController.OrderItemOutPutCurrentPage.value <
//                         totalPages.value
//                         ? whiteColor
//                         : color3,),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       Container(
//         padding: EdgeInsets.only(left: 40, right: 40),
//         child: Row(
//           children: [
//             Txt('${AppController.of(context)!.value('show')}',
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               color: color3,),
//             Txt('${1+ ViewCustomController.getStartIndexOutPutOrderItem()}',
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               color: color3,),
//             Txt('${AppController.of(context)!.value('until')}',
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               color: color3,),
//             Txt('${ViewCustomController.getEndIndexOutPutOrderItem()}', fontSize: 16,
//               fontWeight: FontWeight.w400,
//               color: color3,),
//             Txt('${AppController.of(context)!.value('from')}',
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               color: color3,),
//             Txt('${ViewCustomController.getOrderDetailsOrderSelectedList().length}',
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               color: color3,),
//             Txt('${AppController.of(context)!.value('input')}',
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               color: color3,),
//           ],
//         ),
//       )
//     ];
//
//   }
//
// }
