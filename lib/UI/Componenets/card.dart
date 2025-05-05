import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/img.dart';
import 'package:finance/UI/Componenets/General/myDivider.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'btn.dart';
// class CustomCard extends StatelessWidget {
//   final Widget child;
//   final Color backgroundColor;
//   final double elevation;
//   final double borderRadius;
//   final EdgeInsetsGeometry padding;
//   Color? borderColor;
//
//
//    CustomCard({
//     required this.child,
//     this.backgroundColor = Colors.transparent,
//     this.elevation = 2,
//     this.borderRadius = 8,
//     this.padding = const EdgeInsets.all(16),
//     this.borderColor,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(borderRadius),
//         border: Border.all(color: borderColor! , width: 1),
//         // boxShadow: [
//         //   BoxShadow(
//         //     color: Colors.black.withOpacity(0.1 * elevation),
//         //     blurRadius: elevation * 3,
//         //     spreadRadius: elevation * 0.5,
//         //     offset: Offset(0, elevation),
//         //   ),
//         // ],
//       ),
//       child: Padding(
//         padding: padding,
//         child: child,
//       ),
//     );
//   }
// }


// class CustomCard extends StatelessWidget {
//   final Widget? child;
//   final Widget? cardText; // متن با استایل خاص
//   final Widget? cardImgTop; // تصویر بالایی
//   final Widget? cardImgBottom; // تصویر پایینی
//   final Color backgroundColor;
//   final double elevation;
//   final double borderRadius;
//   final EdgeInsetsGeometry padding;
//   final Color? borderColor;
//   final bool clipTopImage; // آیا تصویر بالایی گوشه‌های گرد داشته باشد؟
//   final bool clipBottomImage; // آیا تصویر پایینی گوشه‌های گرد داشته باشد?
//
//   const CustomCard({
//     this.child,
//     this.cardText,
//     this.cardImgTop,
//     this.cardImgBottom,
//     this.backgroundColor = Colors.transparent,
//     this.elevation = 2,
//     this.borderRadius = 8,
//     this.padding = const EdgeInsets.all(16),
//     this.borderColor,
//     this.clipTopImage = true,
//     this.clipBottomImage = true,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(borderRadius),
//         border: borderColor != null
//             ? Border.all(color: borderColor!, width: 1)
//             : null,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // تصویر بالایی با گوشه‌های گرد
//           if (cardImgTop != null)
//             clipTopImage
//                 ? ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(borderRadius),
//                 topRight: Radius.circular(borderRadius),
//               ),
//               child: cardImgTop!,
//             )
//                 : cardImgTop!,
//
//           // محتوای اصلی
//           Padding(
//             padding: padding,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (child != null) child!,
//                 if (cardText != null)
//                   DefaultTextStyle(
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.black87,
//                       height: 1.5,
//                     ),
//                     child: cardText!,
//                   ),
//               ],
//             ),
//           ),
//
//           // تصویر پایینی با گوشه‌های گرد
//           if (cardImgBottom != null)
//             clipBottomImage
//                 ? ClipRRect(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(borderRadius),
//                 bottomRight: Radius.circular(borderRadius),
//               ),
//               child: cardImgBottom!,
//             )
//                 : cardImgBottom!,
//         ],
//       ),
//     );
//   }
// }

class CustomCard extends StatefulWidget {
  Color? colorBox;
  Color? borderColorBox;
  String? title;
  Color? titleColor;
  String? subTitle;
  Color? subTitleColor;
  String? description;
  Color? desriptionColor;
  Img? imageTop;
  Img? imageBottom;
  Btn? btn;
  List<CardLink>? links;
  List<String>? listItems;
  String? cardHeader;
  Color? cardHeaderOrFooterColor;
  Color? headerOrFooterBackgroundColor;
  Color? listItemColor;
  String? cardFooter;
  bool isCenter;
  double? width;
  EdgeInsets? margin;
  bool isChangedWidthResponsive;
  String? blockquote;
  Color? blockquoteColor;
  bool? isChangeFontWeigth;//h5
  bool? isEnd;
  bool overlayContent;
  String? imgUrl;
  bool? isHorizental;
  Img? imageLeft;
  Img? imageRight;
  int? flexRight;
  int? flexLeft;
  Color? borderColor;
  bool? isEqualHeight;
  double? height;
  CustomCard({
    this.colorBox = whiteColor,
    this.borderColorBox = color28 ,
    this.title ,
    this.titleColor ,
    this.subTitle,
    this.subTitleColor,
    this.description ,
    this.desriptionColor ,
    this.imageTop ,
    this.imageBottom,
    this.btn,
    this.links,
    this.listItems,
    this.cardHeader,
    this.cardHeaderOrFooterColor,
    this.headerOrFooterBackgroundColor,
    this.listItemColor,
    this.cardFooter,
    this.isCenter = false,
    this.width,
    this.margin,
    this.isChangedWidthResponsive = false,
    this.blockquote,
    this.blockquoteColor,
    this.isChangeFontWeigth = false,
    this.isEnd = false,
    this.overlayContent = false,
    this.imgUrl,
    this.isHorizental = false,
    this.imageLeft,
    this.imageRight,
    this.flexRight,
    this.flexLeft,
    this.borderColor,
    this.isEqualHeight = false,
    this.height
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      // width: 288,
      height: widget.isEqualHeight! ? widget.height : null,
      decoration: BoxDecoration(
        color:widget.colorBox,
        border: Border.all(color: this.widget.borderColorBox! , width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: widget.overlayContent ?Stack(
        children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              width: widget.width,
              child: Img(widget.imgUrl!,width: size.width,height: 300, radius: 16,)),
            Box(context),
        ],
      ) :Box(context),
    );
  }
  Widget Box(BuildContext context){
    var size = MediaQuery.of(context).size;
    final textAlign = widget.isCenter ? TextAlign.center : widget.isEnd! ? TextAlign.end:TextAlign.start;
    bool isSmallScreen = false;
    bool isHovered = false;
    if(widget.isChangedWidthResponsive){
      isSmallScreen = size.width < 768;
    }
    return Container(
      // width: size.width,
      width: isSmallScreen  ? size.width : widget.width,
      child: widget.isHorizental! ?
      size.width < 768 ?
      Stack(
        children: [
          if(widget.cardHeader != null)
            Header(size, textAlign),
          if(widget.cardFooter != null)
            Footer(size , textAlign),
          Column(
            children: [
              if(widget.imageLeft != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    color: Colors.blueGrey,

                  ),
                  child: widget.imageLeft!,),
              Body(size , textAlign , isHovered),
              if (widget.imageRight != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),

                    ),
                    color: Colors.blueGrey,

                  ),
                  child: widget.imageRight!,),
            ],
          ),
        ],
      ):
      Stack(
        children: [
          if(widget.cardHeader != null)
            Header(size, textAlign),
          if(widget.cardFooter != null)
            Footer(size , textAlign),
          Row(
            mainAxisAlignment: widget.isCenter ?MainAxisAlignment.center : widget.isEnd! ? MainAxisAlignment.end:MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.imageRight != null)
                Expanded(
                  flex: widget.flexRight!,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(15),

                      ),
                      color: Colors.blueGrey,

                    ),
                    child: widget.imageRight!,),
                ),
              Expanded(
                flex: widget.imageRight != null ? widget.flexLeft! : widget.flexRight!,
                child: Body(size, textAlign, isHovered),
              ),
              if(widget.imageLeft != null)
                Expanded(
                  flex: widget.flexLeft!,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(0)
                      ),
                      color: Colors.blueGrey,

                    ),
                    child: widget.imageLeft!,),
                ),
            ],
          )
        ],
      ) :
      Stack(
        children: [
          if(widget.cardHeader != null)
            Header(size, textAlign),
          if(widget.cardFooter != null)
            Footer(size , textAlign),
          Column(
            children: [
              if (widget.imageTop != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),

                    ),
                    color: Colors.blueGrey,

                  ),
                  child: widget.imageTop!,),
              Body(size , textAlign , isHovered),
              if(widget.imageBottom != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    color: Colors.blueGrey,

                  ),
                  child: widget.imageBottom!,),
            ],
          )
        ],
      )
    );
  }
  Widget Header(var size ,final textAlign){
    return Positioned(
      top:0,
      right: 0,
      left: 0,
      child:  ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        child: Container(
          width:widget.width != null ? widget.width : size.width,
          padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.borderColor != null ?widget.borderColor!: Colors.transparent,
                width: 3,
              ),
            ),

            color: widget.headerOrFooterBackgroundColor,
          ),
          child: Container(
              child: Txt(widget.cardHeader! , color: widget.cardHeaderOrFooterColor,textAlign: textAlign, fontSize: 16, fontWeight: widget.isChangeFontWeigth! ?FontWeight.w600:FontWeight.w400,)),
        ),
      ),);
  }
  Widget Footer(var size ,final textAlign){
    return  Positioned(
      bottom:0,
      left: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        child: Container(
          width: widget.width != null ? widget.width : size.width,
          padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: widget.borderColor != null ?widget.borderColor!: Colors.transparent,
                width: 3,
              ),
            ),
            color: widget.headerOrFooterBackgroundColor,
          ),
          child: Container(
              child: Txt(widget.cardFooter! , color: widget.cardHeaderOrFooterColor,textAlign: textAlign,)),
        ),
      ),);
  }
  Widget Body(var size,final textAlign , bool isHovered){
    return Column(
      crossAxisAlignment: widget.isCenter ?CrossAxisAlignment.center : widget.isEnd! ? CrossAxisAlignment.end:CrossAxisAlignment.start,
      children: [
        if(widget.cardHeader != null)
          SizedBox(height: 40,),
        if(widget.title != null || widget.subTitle != null || widget.description != null)
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(this.widget.title != null)
                  Container(
                      width: size.width,
                      child: Txt(this.widget.title! , fontSize: 20 , fontWeight: FontWeight.w500, color:this.widget.titleColor ,textAlign: textAlign,)),
                if(this.widget.title != null)
                  SizedBox(height: 5,),
                if(this.widget.subTitle != null)
                  Txt(this.widget.subTitle! , fontSize: 20 , fontWeight: FontWeight.w300, color:this.widget.subTitleColor , textAlign: textAlign,),
                if(this.widget.subTitle != null)
                  SizedBox(height: 10,),
                if(this.widget.description != null)
                  Container(
                      width: size.width,
                      child: Txt(this.widget.description! , fontSize: 14, fontWeight: FontWeight.w100 ,color: this.widget.desriptionColor , textAlign: textAlign)),
                if(widget.blockquote != null)
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      padding: EdgeInsets.only(left: 16),
                      child: Txt(widget.blockquote! , fontSize: 14,fontWeight: FontWeight.w200 ,color:  widget.blockquoteColor ?? Colors.grey[800], fontStyle: FontStyle.italic, ))
                // if(this.widget.description != null)
                //   SizedBox(height: 10,),

              ],
            ),
          ),
        if((widget.links != null && widget.links!.isNotEmpty) && widget.listItems != null && widget.listItems!.isNotEmpty)
          MyDivider(),
        if (widget.listItems != null && widget.listItems!.isNotEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (var item in widget.listItems!)
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      // decoration: widget.header != null || widget.subTitle != null || widget.description != null ? BoxDecoration(
                      //   border: Border(
                      //     top: BorderSide(
                      //       color: itemColor25,
                      //     ),
                      //     bottom: BorderSide(
                      //       color: itemColor25,
                      //     ),
                      //   )
                      // ):null,
                      width: size.width,
                      child: Txt(
                        item,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: widget.listItemColor,
                        textAlign: textAlign,
                      ),
                    ),
                    if (item != widget.listItems!.last)
                      MyDivider(),
                  ],
                ),
            ],
          ),
        if((widget.links != null && widget.links!.isNotEmpty) && widget.listItems != null && widget.listItems!.isNotEmpty)
          MyDivider(),
        // SizedBox(height: 15,),
        if (widget.links != null && widget.links!.isNotEmpty)
          Wrap(
              spacing: 16,
              children: [
                for(var link in this.widget.links!)
                  MouseRegion(
                    onEnter: (_){
                      setState(() {
                        isHovered = true;
                        print('isHovered>>>${isHovered}');
                      });
                    },
                    onExit: (_){
                      setState(() {
                        isHovered = false;
                      });
                    },
                    child: InkWell(
                        onTap: (){
                          if(link.onTap != null){
                            link.onTap!();
                          }
                        },
                        child: Container(
                            padding: EdgeInsets.all(16),
                            child: Txt(link.text , color: isHovered ? linkHoverColor : linkColor, textDecoration: TextDecoration.underline, fontSize: 14,fontWeight: FontWeight.w100 , textAlign: textAlign, ))),
                  )
              ]
          ),
        if(widget.btn != null) Container(padding: EdgeInsets.all(16),child: widget.btn!,),
        if(widget.cardFooter != null)
          SizedBox(height: 40,),
      ],
    );
  }
}
class CardLink {
   String text;
  VoidCallback? onTap;

  CardLink({
    required this.text,
    this.onTap,
  });
}
