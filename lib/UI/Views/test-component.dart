import 'package:finance/Public/images.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/accordion.dart';
import 'package:finance/UI/Componenets/alert.dart';
import 'package:finance/UI/Componenets/alert.dart';
import 'package:finance/UI/Componenets/badge.dart';
import 'package:finance/UI/Componenets/breadCrumb.dart';
import 'package:finance/UI/Componenets/btn-group/btn-group-item.dart';
import 'package:finance/UI/Componenets/btn-group/btn-group.dart';
import 'package:finance/UI/Componenets/btn.dart';
import 'package:finance/UI/Componenets/card.dart';
import 'package:finance/UI/Componenets/carousel-slider.dart';
import 'package:finance/UI/Componenets/close-btn.dart';
import 'package:finance/UI/Componenets/collapse.dart';
import 'package:finance/UI/Componenets/dissmisiable-alert.dart';
import 'package:finance/UI/Componenets/dropDown/drop-down-item.dart';
import 'package:finance/UI/Componenets/dropDown/drop-down.dart';
import 'package:finance/UI/Componenets/form.dart';
import 'package:finance/UI/Componenets/modal.dart';
import 'package:finance/UI/Componenets/placeholder/btn-placeholder.dart';
import 'package:finance/UI/Componenets/placeholder/content-placeholder.dart';
import 'package:finance/UI/Componenets/placeholder/img-placeholder.dart';
import 'package:finance/UI/Componenets/popOvers.dart';
import 'package:finance/UI/Componenets/progress/progress-item.dart';
import 'package:finance/UI/Componenets/progress/progress.dart';
import 'package:finance/UI/Componenets/spinner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestComponent extends StatelessWidget {
  const TestComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(height: 30),
        //acccordian
        CustomAccordion(accordianTitle: 'item1' ,
            accordianTitleColor: redColor ,
            accordianBoxColor: Colors.lightBlueAccent ,
            accordianDescription: 'des1' ,
            accordianDescriptionColor: Colors.black ,
            colorIcon: color20 ,
            colorBoxDescription: Colors.black26,
          width: 600,
          isOpen: true,
        ),
        SizedBox(height: 30),
        CustomAccordion(accordianTitle: 'item2' ,accordianTitleColor: Colors.blue , accordianBoxColor: Colors.white , accordianDescription: 'des2' , accordianDescriptionColor: Colors.yellow , colorIcon: color20 , colorBoxDescription: Colors.pink),
        SizedBox(height: 30),
        Alert(type: alertType.secondary,content: Row(
          children: [
            Txt('sssssss', fontSize: 16, fontWeight: FontWeight.w400,),
            InkWell(
              onTap: (){},
                child: Txt('sssssss', fontSize: 16, fontWeight: FontWeight.w700,textDecoration: TextDecoration.underline, )),
            Txt('sssssss', fontSize: 16, fontWeight: FontWeight.w400,),
          ],
        ) ,),
        SizedBox(height: 30),
        SizedBox(height: 30),
        //badge
        BadgeCustom(colorBox: Colors.red,value: Txt('4'), width: 30,height: 30,borderRadius: 10),
        SizedBox(height: 30),
        Btn(type: btnType.primary, content:Row(
          children: [
            BadgeCustom(colorBox: Colors.red,value: Txt('4'), width: 30,height: 30,borderRadius: 10),
            SizedBox(width: 5,),
            Txt('primary'),
          ],
        ),width: 150,),
        SizedBox(height: 30),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Btn(type: btnType.primary ,content: Txt('primary'),width: 150,),
            Positioned(
                top: -15,
                right: -15,
                child: BadgeCustom(colorBox: Colors.red,value: Txt('4'), width: 30,height: 30,borderRadius: 10)
            ),
          ],
        ),
        SizedBox(height: 30),
        Breadcrumb(
          itemClickedColor: Colors.blue,
          itemColor: Colors.red,

          alignment: MainAxisAlignment.end,
          direction: Axis.vertical,
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
        SizedBox(height: 30),
        Btn(type:btnType.primary ,content: Txt('primary'),),
        SizedBox(height: 30),
        Btn(type:btnType.secondary, content: Txt('secondary'),),
        SizedBox(height: 30),
        Btn(type:btnType.success, content: Txt('success'),),
        SizedBox(height: 30),
        Btn(type:btnType.danger, content: Txt('danger'),),
        SizedBox(height: 30),
        Btn(type:btnType.warning, content: Txt('warning'),),
        SizedBox(height: 30),
        Btn(type:btnType.info, content: Txt('info'),),
        SizedBox(height: 30),
        Btn(type:btnType.light, content: Txt('light'),),
        SizedBox(height: 30),
        Btn(type:btnType.dark, content: Txt('dark'),),

        //outline
        SizedBox(height: 30),
        Btn(type:btnType.primary ,content: Txt('primary'),isOutline: true),
        SizedBox(height: 30),
        Btn(type:btnType.secondary, content: Txt('secondary'),isOutline: true),
        SizedBox(height: 30),
        Btn(type:btnType.success, content: Txt('success'),isOutline: true),
        SizedBox(height: 30),
        Btn(type:btnType.danger, content: Txt('danger'),isOutline: true),
        SizedBox(height: 30),
        Btn(type:btnType.warning, content: Txt('warning'),isOutline: true),
        SizedBox(height: 30),
        Btn(type:btnType.info, content: Txt('info'),isOutline: true),
        SizedBox(height: 30),
        Btn(type:btnType.light, content: Txt('light'),isOutline: true),
        SizedBox(height: 30),
        Btn(type:btnType.dark, content: Txt('dark'),isOutline: true),

        //disable
        SizedBox(height: 30),
        Btn(type:btnType.primary ,content: Txt('primary'),disabled: true,),
        SizedBox(height: 30),
        Btn(type:btnType.secondary, content: Txt('secondary'),disabled: true,),
        SizedBox(height: 30),
        Btn(type:btnType.success, content: Txt('success'),disabled: true,),
        SizedBox(height: 30),
        Btn(type:btnType.danger, content: Txt('danger'),disabled: true,),
        SizedBox(height: 30),
        Btn(type:btnType.warning, content: Txt('warning'),disabled: true,),
        SizedBox(height: 30),
        Btn(type:btnType.info, content: Txt('info'),disabled: true,),
        SizedBox(height: 30),
        Btn(type:btnType.light, content: Txt('light'),disabled: true,),
        SizedBox(height: 30),
        Btn(type:btnType.dark, content: Txt('dark'),disabled: true,),

        SizedBox(height: 60),
        //disable and outline
        Btn(type:btnType.primary ,content: Txt('primary'),disabled: true,isOutline: true),
        SizedBox(height: 30),
        Btn(type:btnType.secondary, content: Txt('secondary'),disabled: true,isOutline: true),
        SizedBox(height: 30),
        Btn(type:btnType.success, content: Txt('success'),disabled: true,isOutline: true),
        SizedBox(height: 30),
        Btn(type:btnType.danger, content: Txt('danger'),disabled: true,isOutline: true),
        SizedBox(height: 30),
        Btn(type:btnType.warning, content: Txt('warning'),disabled: true,isOutline: true),
        SizedBox(height: 30),
        Btn(type:btnType.info, content: Txt('info'),disabled: true,isOutline: true),
        SizedBox(height: 30),
        Btn(type:btnType.light, content: Txt('light'),disabled: true,isOutline: true),
        SizedBox(height: 30),
        Btn(type:btnType.dark, content: Txt('dark'),disabled: true,isOutline: true),

        SizedBox(height: 60),
        //toggle
        Btn(type: btnType.primary,content: Txt('primary'),isToggle: true , isActive: true,),
        Btn(type: btnType.primary,content: Txt('primary')),
        Btn(content: Txt('primary'),isToggle: true , isActive: true,),
        SizedBox(height: 30),



        // //btn
        // Btn(colorBtn: Colors.blue , content: Txt('primary'), hoverBtnColor: Colors.blueAccent, isBlock: true),
        // SizedBox(height: 30),
        // Btn(colorBtn: Colors.green , content: Txt('primary2') , hoverBtnColor: Colors.greenAccent,size: ButtonSize.large, ),
        // SizedBox(height: 30),
        // Btn(colorBtn: Colors.green , content: Txt('primary3'), hoverBtnColor: Colors.greenAccent,isToggle: true),
        // SizedBox(height: 30),
        // Btn(colorBtn: Colors.green , content: Txt('primary4'), hoverBtnColor: Colors.greenAccent,isToggle: true),
        // SizedBox(height: 30),
        // Btn(colorBtn: Colors.green , content: Txt('primary5'), hoverBtnColor: Colors.greenAccent,size: ButtonSize.small,),
        // SizedBox(height: 30),
        // Btn(colorBtn: Colors.green , content: Txt('d-md-block'), hoverBtnColor: Colors.greenAccent,responsive: true,),
        // SizedBox(height: 30),
        // Btn(colorBtn: Colors.green , content: Txt('col-6 mx-auto'), hoverBtnColor: Colors.greenAccent, responsive: true,isCenter: true,),


        SizedBox(height: 30),

        MyCarousel(items: [
          CarouselItem(
            imageUrl:  loginSvg,
          ),
          CarouselItem(
            imageUrl:  test,
          ),
          CarouselItem(
            imageUrl:  loginSvg,
          ),
        ]),
        SizedBox(height: 30),
        //Indicators
        MyCarousel(items: [
          CarouselItem(
            imageUrl:  loginSvg,
          ),
          CarouselItem(
            imageUrl:  test,
          ),
          CarouselItem(
            imageUrl:  loginSvg,
          ),
        ],showIndicators: true),
        SizedBox(height: 30),
        //Captions
        MyCarousel(items: [
          CarouselItem(
            imageUrl:  loginSvg,
            caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
          ),
          CarouselItem(
            imageUrl:  test,
            caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
          ),
          CarouselItem(
            imageUrl:  loginSvg,
            caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
          ),
        ],showIndicators: true , hasCaption: true),
        SizedBox(height: 30),
        //Autoplaying
        MyCarousel(items: [
          CarouselItem(
            imageUrl:  loginSvg,
            caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
          ),
          CarouselItem(
            imageUrl:  test,
            caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
          ),
          CarouselItem(
            imageUrl:  loginSvg,
            caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
          ),
        ],showIndicators: true , hasCaption: true , isAutoPlay: true),
        SizedBox(height: 30),
        //ride
        MyCarousel(items: [
          CarouselItem(
            imageUrl:  loginSvg,
            caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
          ),
          CarouselItem(
            imageUrl:  test,
            caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
          ),
          CarouselItem(
            imageUrl:  loginSvg,
            caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
          ),
        ],showIndicators: true , hasCaption: true ,ride: true),
        SizedBox(height: 30),
        //Individual .carousel-item interval
        MyCarousel(items: [
          CarouselItem(
            imageUrl:  loginSvg,
            caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
            autoPlayInterval: Duration(seconds: 10),
          ),
          CarouselItem(
            imageUrl:  test,
            caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
            autoPlayInterval: Duration(seconds: 20),
          ),
          CarouselItem(
            imageUrl:  loginSvg,
            caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
            autoPlayInterval: Duration(seconds: 40),
          ),
        ],showIndicators: true , hasCaption: true , isAutoPlay: true),
        SizedBox(height: 30),
        //Autoplaying carousels without controls
        MyCarousel(items: [
          CarouselItem(
            imageUrl:  loginSvg,
            caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),

          ),
          CarouselItem(
            imageUrl:  test,
            caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),

          ),
          CarouselItem(
            imageUrl:  loginSvg,
            caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
          ),
        ],showIndicators: true , hasCaption: true , isAutoPlay: true , hasControl: true),
        SizedBox(height: 30),
        //Disable touch swiping
        MyCarousel(items: [
          CarouselItem(
            imageUrl:  loginSvg,
            caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
          ),
          CarouselItem(
            imageUrl:  test,
            caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
          ),
          CarouselItem(
            imageUrl:  loginSvg,
            caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
          ),
        ],showIndicators: true , hasCaption: true , isAutoPlay: true ,hasTouchSwipping: false),
        SizedBox(height: 30),
        //Dark variant
        MyCarousel(items: [
          CarouselItem(
            imageUrl:  loginSvg,
            caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
          ),
          CarouselItem(
            imageUrl:  test,
            caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
          ),
          CarouselItem(
            imageUrl:  loginSvg,
            caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
          ),
        ],showIndicators: true , hasCaption: true , colorBox: color25,colorIcon: color26,colorIndicator: color26,colorIndicatorActive: blackColor,colorTxt: blackColor, isAutoPlay: true),
        SizedBox(height: 30),
        //Crossfade
        MyCarousel(items: [
          CarouselItem(
            imageUrl:  loginSvg,
            caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
          ),
          CarouselItem(
            imageUrl:  test,
            caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
          ),
          CarouselItem(
            imageUrl:  loginSvg,
            caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
          ),
        ],showIndicators: true , hasCaption: true , isAutoPlay: true  , isCrossFade: true),
        // //card
        // SizedBox(height: 30),
        // CustomCard(
        //   title: 'aaaaaaaaaaaaaaaaaaaaaaabbbb',
        //   description: 'bbbbbbbbb',
        //   titleColor: blackColor,
        //   desriptionColor: Colors.red,
        //   imageTop: Img(loginSvg),
        //   btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, content: Txt('dddddddddddddd') , ),
        // ),
        // SizedBox(height: 30),
        // //Titles, text, and links
        // CustomCard(
        //   title: 'Card title',
        //   subTitle: 'Card subtitle',
        //   subTitleColor: Colors.pink,
        //   description: 'Some quick example text to build on the card title and make up the bulk of the card',
        //   titleColor: blackColor,
        //   desriptionColor: Colors.red,
        //   links: [
        //     CardLink(text: 'Card link' , onTap: (){}),
        //     CardLink(text: 'Another link' , onTap: (){})
        //   ],
        // ),
        // SizedBox(height: 30),
        // //Images
        // CustomCard(
        //   description: 'Some quick example text to build on the card title and make up the bulk of ',
        //   titleColor: blackColor,
        //   desriptionColor: Colors.red,
        //   imageTop: Img(loginSvg),
        // ),
        // SizedBox(height: 30),
        // //List groups
        // CustomCard(
        //   listItems: [
        //     'An item',
        //     'A second item',
        //     'A third item'
        //   ],
        // ),
        // SizedBox(height: 30),
        // //List groups card-header
        // CustomCard(
        //   cardHeader: 'Featured',
        //   headerOrFooterBackgroundColor: Colors.red,
        //   cardHeaderOrFooterColor: darkBackground,
        //   listItemColor: color1,
        //   listItems: [
        //     'An item',
        //     'A second item',
        //     'A third item'
        //   ],
        // ),
        // SizedBox(height: 30),
        // //List groups card-footer
        // CustomCard(
        //   cardFooter: 'Card footer',
        //   headerOrFooterBackgroundColor: Colors.red,
        //   cardHeaderOrFooterColor: darkBackground,
        //   listItemColor: color1,
        //   listItems: [
        //     'An item',
        //     'A second item',
        //     'A third item'
        //   ],
        // ),
        // SizedBox(height: 30),
        // //Kitchen sink
        // CustomCard(
        //   imageTop: Img(loginSvg),
        //   title: 'Card title',
        //   description: 'Some quick example text to build on the card title and make up the bulk of the card',
        //   titleColor: darkBackground,
        //   desriptionColor: darkBackground,
        //   links: [
        //     CardLink(text: 'Card link' , onTap: (){}),
        //     CardLink(text: 'Another link' , onTap: (){})
        //   ],
        //   listItems: [
        //     'An item',
        //     'A second item',
        //     'A third item'
        //   ],
        // ),
        // SizedBox(height: 30),
        // //Header and footer
        // CustomCard(
        //   cardHeader: 'Featured',
        //   cardHeaderOrFooterColor: darkBackground,
        //   headerOrFooterBackgroundColor: Colors.red,
        //   title: 'Special title treatment',
        //   description: 'With supporting text below as a natural lead-in to additional content.',
        //   titleColor: darkBackground,
        //   desriptionColor: darkBackground,
        //   btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, content: Txt('dddddddddddddd'), ),
        // ),
        // SizedBox(height: 30),
        // //center
        // CustomCard(
        //   cardHeader: 'Featured',
        //   cardHeaderOrFooterColor: darkBackground,
        //   headerOrFooterBackgroundColor: Colors.red,
        //   title: 'Special title treatment',
        //   description: 'With supporting text below as a natural lead-in to additional content.',
        //   titleColor: darkBackground,
        //   desriptionColor: darkBackground,
        //   btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, content: Txt('dddddddddddddd'), ),
        //   cardFooter:'2 days ago',
        //   isCenter: true,
        // ),
        // SizedBox(height: 30),
        // //Sizing
        // //Using grid markup
        // Container(
        //   width: size.width,
        //   child: Wrap(
        //     crossAxisAlignment: WrapCrossAlignment.start,
        //     alignment: WrapAlignment.start,
        //     spacing: 16,
        //     runSpacing: 16,
        //     children: [
        //       CustomCard(
        //         title: 'Special title treatment',
        //         description: 'With supporting text below as a natural lead-in to additional content.',
        //         titleColor: darkBackground,
        //         desriptionColor: darkBackground,
        //         btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, content: Txt('dddddddddddddd'), ),
        //         width: (size.width / 2) - 32,
        //         margin: EdgeInsets.only(bottom: 16),
        //         isChangedWidthResponsive: true,
        //       ),
        //       // SizedBox(width: 10,),
        //       CustomCard(
        //         title: 'Special title treatment',
        //         description: 'With supporting text below as a natural lead-in to additional content.',
        //         titleColor: darkBackground,
        //         desriptionColor: darkBackground,
        //         btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, content: Txt('dddddddddddddd'), ),
        //         width:(size.width / 2 )- 32,
        //         isChangedWidthResponsive: true,
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(height: 30),
        // //Using utilities
        // Container(
        //   width: size.width,
        //   child: Wrap(
        //     crossAxisAlignment: WrapCrossAlignment.start,
        //     alignment: WrapAlignment.start,
        //     spacing: 16,
        //     runSpacing: 16,
        //     children: [
        //       CustomCard(
        //         title: 'Special title treatment',
        //         description: 'With supporting text below as a natural lead-in to additional content.',
        //         titleColor: darkBackground,
        //         desriptionColor: darkBackground,
        //         btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, content: Txt('dddddddddddddd'), ),
        //         width: (size.width * 0.75) - 32,
        //         margin: EdgeInsets.only(bottom: 16),
        //       ),
        //       // SizedBox(width: 10,),
        //       CustomCard(
        //         title: 'Special title treatment',
        //         description: 'With supporting text below as a natural lead-in to additional content.',
        //         titleColor: darkBackground,
        //         desriptionColor: darkBackground,
        //         btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, content: Txt('dddddddddddddd'), ),
        //         width:(size.width * 0.25 )- 32,
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(height: 30),
        // //Using custom CSS
        // CustomCard(
        //   title: 'Special title treatment',
        //   description: 'With supporting text below as a natural lead-in to additional content.',
        //   titleColor: darkBackground,
        //   desriptionColor: darkBackground,
        //   btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, content: Txt('dddddddddddddd'), ),
        //   width: 300,
        // ),
        // SizedBox(height: 30),
        // //blockquote
        // CustomCard(
        //   title: 'Special title treatment',
        //   titleColor: darkBackground,
        //   blockquote: 'Someone famous in ',
        // ),
        // SizedBox(height: 30),
        // //<h*>
        // CustomCard(
        //   title: 'Special title treatment',
        //   titleColor: darkBackground,
        //   cardHeader: 'Featured',
        //   cardHeaderOrFooterColor: darkBackground,
        //   headerOrFooterBackgroundColor: Colors.red,
        //   description: 'With supporting text below as a natural lead-in to additional content.',
        //   desriptionColor: darkBackground,
        //   isChangeFontWeigth: true,
        //
        // ),
        // SizedBox(height: 30),
        // //Text alignment
        // //start
        // CustomCard(
        //   title: 'Special title treatment start',
        //   description: 'With supporting text below as a natural lead-in to additional content.',
        //   titleColor: darkBackground,
        //   desriptionColor: darkBackground,
        //   btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, content: Txt('dddddddddddddd'), ),
        //   width: 500,
        // ),
        // SizedBox(height: 30),
        // //center
        // CustomCard(
        //   title: 'Special title treatment center',
        //   description: 'With supporting text below as a natural lead-in to additional content.',
        //   titleColor: darkBackground,
        //   desriptionColor: darkBackground,
        //   btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, content: Txt('dddddddddddddd') ),
        //   width: 500,
        //   isCenter: true,
        // ),
        // SizedBox(height: 30),
        // //end
        // CustomCard(
        //   title: 'Special title treatment end',
        //   description: 'With supporting text below as a natural lead-in to additional content.',
        //   titleColor: darkBackground,
        //   desriptionColor: darkBackground,
        //   btn: Btn(btnType.custom , color:Colors.blueAccent , hoverColor: Colors.blue, content: Txt('dddddddddddddd'), ),
        //   width: 500,
        //   isEnd: true,
        // ),
        //
        //
        // SizedBox(height: 30),
        // //Image caps
        // //image-top
        // CustomCard(
        //   title: 'Card title',
        //   description: 'Some quick example text to build on the card title and make up the bulk of ',
        //   titleColor: blackColor,
        //   desriptionColor: Colors.red,
        //   imageTop: Img(loginSvg),
        // ),
        // SizedBox(height: 30),
        // //image-bottom
        // CustomCard(
        //   title: 'Card title',
        //   description: 'Some quick example text to build on the card title and make up the bulk of ',
        //   titleColor: blackColor,
        //   desriptionColor: Colors.red,
        //   imageBottom: Img(loginSvg),
        // ),
        // SizedBox(height: 30),
        // //image-overlay
        // CustomCard(
        //   borderColorBox: blackColor,
        //   title: 'Card title',
        //   description: 'Some quick example text to build on the card title and make up the bulk of ',
        //   titleColor: blackColor,
        //   desriptionColor: whiteColor,
        //   overlayContent: true,
        //   imgUrl: test,
        // ),
        // SizedBox(height: 30),
        // //Horizontal
        // CustomCard(
        //   title: 'Card title',
        //   description: 'Some quick example text to build on the card title and make up the bulk of ',
        //   titleColor: blackColor,
        //   desriptionColor: Colors.red,
        //   imageRight: Img(loginSvg ,height: 200,),
        //   width: 600,
        //   isHorizental: true,
        //   flexRight: 2,
        //   flexLeft: 3,
        // ),
        // SizedBox(height: 30),
        // //Background and color
        // CustomCard(
        //   borderColorBox: Colors.blue,
        //   cardFooter: 'Header',
        //   cardHeaderOrFooterColor: blackColor,
        //   headerOrFooterBackgroundColor:Colors.greenAccent,
        //   borderColor: Colors.yellow,
        //   title: 'aaaaaaaaaaaaaaaaaaaaaaabbbb',
        //   description: 'bbbbbbbbb',
        //   titleColor: blackColor,
        //   desriptionColor: blackColor,
        //   width: 300,
        // ),
        // SizedBox(height: 30),
        // //Card groups
        // Wrap(
        //   children: [
        //     CustomCard(
        //       borderColorBox: Colors.blue,
        //       cardFooter: 'Header',
        //       cardHeaderOrFooterColor: blackColor,
        //       headerOrFooterBackgroundColor:Colors.greenAccent,
        //       borderColor: Colors.yellow,
        //       title: 'Card title',
        //       description: 'This card has supporting text below as a natural lead-in to additional content.',
        //       titleColor: blackColor,
        //       desriptionColor: blackColor,
        //       width: 300,
        //       isEqualHeight: true,
        //       height: 300,
        //     ),
        //     CustomCard(
        //       borderColorBox: Colors.blue,
        //       cardFooter: 'Header',
        //       cardHeaderOrFooterColor: blackColor,
        //       headerOrFooterBackgroundColor:Colors.greenAccent,
        //       borderColor: Colors.yellow,
        //       title: 'Card title',
        //       description: 'This is a wider card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.',
        //       titleColor: blackColor,
        //       desriptionColor: blackColor,
        //       width: 300,
        //       isEqualHeight: true,
        //       height: 300,
        //     ),
        //     CustomCard(
        //       borderColorBox: Colors.blue,
        //       cardFooter: 'Header',
        //       cardHeaderOrFooterColor: blackColor,
        //       headerOrFooterBackgroundColor:Colors.greenAccent,
        //       borderColor: Colors.yellow,
        //       title: 'Card title',
        //       description: 'This is a wider card with supporting text below as a natural lead-in to additional content. This card has even longer content than the first to show that equal height action.',
        //       titleColor: blackColor,
        //       desriptionColor: blackColor,
        //       width: 300,
        //       isEqualHeight: true,
        //       height: 300,
        //     ),
        //   ],
        // ),
        //


        SizedBox(height: 30,),
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
        // Container(
        //   width: size.width,
        //   color: Colors.red,
        //   child: Center(
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Dropdown(
        //           itemsDropDown: [
        //             DropdownItem(text: "Dropdown item text"),
        //             DropdownItem(text: "Action", value: "action"),
        //             DropdownItem(text: "Another action", value: "another_action"),
        //             DropdownItem(text: "Something else here", value: "something_else"),
        //           ], dropDownTitle: 'left align menu', direction: directions.left,
        //         ),
        //         SizedBox(height: 10,),
        //         //right
        //         Dropdown(
        //           itemsDropDown: [
        //             DropdownItem(text: "Dropdown item text"),
        //             DropdownItem(text: "Action", value: "action"),
        //             DropdownItem(text: "Another action", value: "another_action"),
        //             DropdownItem(text: "Something else here", value: "something_else"),
        //           ], dropDownTitle: 'right align menu', direction: directions.right,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
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
        SizedBox(height:40),
        // data-bs-offset
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Dropdown(
              itemsDropDown: [
                DropdownItem(text: "Dropdown item text"),
                DropdownItem(text: "Action", value: "action"),
                DropdownItem(text: "Another action", value: "another_action",),
                DropdownItem(text: "Something else here", value: "something_else"),
              ], dropDownTitle: 'change offset', isChangeOffset: true, offsetX: -180, offsetY: 80,
            ),
          ],
        ),
        SizedBox(height:100),


        //Modal
        CustomModal(title: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Launch demo modal',),
        SizedBox(height:40),
        CustomModal(title: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Launch static backdrop modal',staticBackdrop: true),
        SizedBox(height:40),
        CustomModal(title: 'ssss',body: Txt('Where can I get some There are many variations of passages of Lorem Ipsum available, but '
            'the majority have suffered alteration in some form, by injected humour, or r'
            'andomised words which dont look even slightly believable. If you are going to'
            ' use a passage of Lorem Ipsum, you need to be sure there isnt anything embarras'
            'sing hidden in the middle of text. All the Lorem Ipsum generators on the Internet t'
            'end to repeat predefined chunks as necessary, making this the first true generator '
            'on the Internet. It uses a dictionary of over 200 Latin words, combined with a handfu'
            'l of model sentence structures, to generate Lorem Ipsum which looks reasonable. The '
            'generated Lorem Ipsum is therefore always free from repetition, injected h'
            'umour, or non-characteristic words etc.ffffffffffffffffffffffffffffffffdsss'
            'sssssssssssssssssssssssssssssssssssssss Lorem Ipsum is simply dummy text of'
            ' the printing and typesetting industry. Lorem Ipsum has been the industrys '
            'standard dummy text ever since the 1500s, when an unknown printer took a gal'
            'ley of type and scrambled it to make a type specimen book. It has survived not'
            ' only five centuries, but also the leap into electronic typesetting, remaining '
            'essentially unchanged. It was popularised in the 1960s with the release of '
            ' sheets containing Lorem Ipsum passages, and more recently with desktop publishing '
            'software like Aldus PageMaker including versions of Lorem Ipsumhhhhhhhhhhhhhhhhhhhhh'
            'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhwill uncover many web sites still in their infancy. '
            'Various versions have evol' , fontSize: 16, fontWeight: FontWeight.w400,),
            titleBox: 'Save Message', btnTxt: 'Scrolling long content'),
        SizedBox(height:40),
        CustomModal(title: 'ssss',body: Txt('Where can I get some There are many variations of passages of Lorem Ipsum available, but '
            'the majority have suffered alteration in some form, by injected humour, or r'
            'andomised words which dont look even slightly believable. If you are going to'
            ' use a passage of Lorem Ipsum, you need to be sure there isnt anything embarras'
            'sing hidden in the middle of text. All the Lorem Ipsum generators on the Internet t'
            'end to repeat predefined chunks as necessary, making this the first true generator '
            'on the Internet. It uses a dictionary of over 200 Latin words, combined with a handfu'
            'l of model sentence structures, to generate Lorem Ipsum which looks reasonable. The '
            'generated Lorem Ipsum is therefore always free from repetition, injected h'
            'umour, or non-characteristic words etc.ffffffffffffffffffffffffffffffffdsss'
            'sssssssssssssssssssssssssssssssssssssss Lorem Ipsum is simply dummy text of'
            ' the printing and typesetting industry. Lorem Ipsum has been the industrys '
            'standard dummy text ever since the 1500s, when an unknown printer took a gal'
            'ley of type and scrambled it to make a type specimen book. It has survived not'
            ' only five centuries, but also the leap into electronic typesetting, remaining '
            'essentially unchanged. It was popularised in the 1960s with the release of '
            ' sheets containing Lorem Ipsum passages, and more recently with desktop publishing '
            'software like Aldus PageMaker including versions of Lorem Ipsumhhhhhhhhhhhhhhhhhhhhh'
            'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhwill uncover many web sites still in their infancy. '
            'Various versions have evol' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Vertically centered modal',isModalDialogCenter: true),
        SizedBox(height:40),
        CustomModal(title: 'ssss',body: Txt('Where can I get some There are many variations of passages of Lorem Ipsum available, but '
            'the majority have suffered alteration in some form, by injected humour, or r'
            'andomised words which dont look even slightly believable. If you are going to'
            ' use a passage of Lorem Ipsum, you need to be sure there isnt anything embarras'
            'sing hidden in the middle of text. All the Lorem Ipsum generators on the Internet t'
            'end to repeat predefined chunks as necessary, making this the first true generator '
            'on the Internet. It uses a dictionary of over 200 Latin words, combined with a handfu'
            'l of model sentence structures, to generate Lorem Ipsum which looks reasonable. The '
            'generated Lorem Ipsum is therefore always free from repetition, injected h'
            'umour, or non-characteristic words etc.ffffffffffffffffffffffffffffffffdsss'
            'sssssssssssssssssssssssssssssssssssssss Lorem Ipsum is simply dummy text of'
            ' the printing and typesetting industry. Lorem Ipsum has been the industrys '
            'standard dummy text ever since the 1500s, when an unknown printer took a gal'
            'ley of type and scrambled it to make a type specimen book. It has survived not'
            ' only five centuries, but also the leap into electronic typesetting, remaining '
            'essentially unchanged. It was popularised in the 1960s with the release of '
            ' sheets containing Lorem Ipsum passages, and more recently with desktop publishing '
            'software like Aldus PageMaker including versions of Lorem Ipsumhhhhhhhhhhhhhhhhhhhhh'
            'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhwill uncover many web sites still in their infancy. '
            'Various versions have evol' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Vertically centered scrollable modal',isModalDialogCenter: true),
        SizedBox(height:40),
        //size.............
        CustomModal(title: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Small Modal',modalSize: ModalSize.small),
        SizedBox(height:40),
        CustomModal(title: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Default Modal',),
        SizedBox(height:40),
        CustomModal(title: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Large Modal',modalSize: ModalSize.large),
        SizedBox(height:40),
        CustomModal(title: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Extra Large Modal', modalSize: ModalSize.xlarge),
        SizedBox(height:40),
        CustomModal(title: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Full Screen', modalSize: ModalSize.fullScreen),
        SizedBox(height:40),
        //fullscrenn responsive
        CustomModal(title: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Full screen below sm', modalFullscreenMode: ModalFullscreenMode.smDown),
        SizedBox(height:40),
        CustomModal(title: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Full screen below md', modalFullscreenMode: ModalFullscreenMode.mdDown),
        SizedBox(height:40),
        CustomModal(title: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Full screen below lg', modalFullscreenMode: ModalFullscreenMode.lgDown),
        SizedBox(height:40),
        CustomModal(title: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Full screen below xl', modalFullscreenMode: ModalFullscreenMode.xlDown),
        SizedBox(height:40),
        CustomModal(title: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Full screen below xxl', modalFullscreenMode: ModalFullscreenMode.xxlDown),
        SizedBox(height:100),
        //placeholder
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ImgPlaceholder(animationType: PlaceholderAnimationType.glow , width: 50,),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ContentPlaceholder(width: 200 , animationType: PlaceholderAnimationType.wave,),
                    ContentPlaceholder(width: 150 , animationType: PlaceholderAnimationType.glow),
                    ContentPlaceholder(width: 180),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10,),
            ButtonPlaceholder(width: 200,)

          ],
        ),
        SizedBox(height:40),
        //popOvers
        Container(
            width:size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopOverWidget(btnTxt: 'Click to toggle popover', btnColor: Colors.pinkAccent, btnHoverColor: Colors.pink, popOverBody: 'And here’s some amazing content. It’s very engaging. Right?',direction: d.left , disabled: true),
              ],
            )),
        SizedBox(height:40),
        //progressbar
        MultiColorProgressBar(items: [
          ProgressItem(
            value: 25,
            progressBarolor: Colors.blue,
            // hasStriped: true,
            showLabel: true,
          ),
          ProgressItem(
            value: 50,
            progressBarolor: Colors.green,
            showLabel: true,
          ),
          ProgressItem(
            value: 10,
            progressBarolor: Colors.teal,
            showLabel: true,
          ),

        ],),
        SizedBox(height:40),
        //button group
        ButtonGroup(
          buttons: [
            ButtonItem(contetnBtn: Txt('left', color: whiteColor, fontSize:16, fontWeight: FontWeight.w400,textAlign: TextAlign.center,),),
            ButtonItem(contetnBtn: Txt('middel', color: whiteColor, fontSize:16, fontWeight: FontWeight.w400,textAlign: TextAlign.center,) , isChechked: true , ),
            ButtonItem(contentBtnDropDown: 'drop down' ,isDropdown: true , itemsDropDown: [
              DropdownItem(text: "Dropdown item text", isHeader: true ),
              DropdownItem(text: "Action", value: "action"),
              DropdownItem(text: "Another action", value: "another_action"),
              DropdownItem(text: "Something else here", value: "something_else"),
            ]  , ),
            ButtonItem(contetnBtn: Txt('right', color: whiteColor, fontSize:16, fontWeight: FontWeight.w400,textAlign: TextAlign.center,)  , ),
          ],
          spacing: 0,
          borderRadius: 4.0,
        ),
        SizedBox(height:40),
        //spinners
        Spinner(color: redColor,alignment: SpinnerAlignment.end),
        SizedBox(height:40),
        Spinner(color: redColor,type: SpinnerType.grow ,size: 48),
        SizedBox(height:40),
        Btn(type:btnType.primary , disabled: true,content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Spinner(color: whiteColor , type: SpinnerType.grow, size: 15,),
          ],
        ),),
        SizedBox(height:40),
        MyFormPage(),
        SizedBox(height:40),
        CustomCard(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Txt('card title' , fontSize: 20, fontWeight: FontWeight.w500,),
              SizedBox(height: 5,),
              Txt('card subtitle' , fontSize: 16, fontWeight: FontWeight.w500,),
              SizedBox(height: 10,),
              Txt('This is some text within a card body.' , fontSize: 16, fontWeight: FontWeight.w400,),
              SizedBox(height: 20,),
              Txt('Card Link' , fontSize: 16, fontWeight: FontWeight.w400,textDecoration: TextDecoration.underline , color: Colors.blue,),
            ],
          ),
          // imageTop: Img(loginSvg),
          // imageBottom: Img(loginSvg),
          // cardFooter: 'Featured',
          // cardHeader: 'Featured',
          // horizental: true,
          imageOverlay: true,
          imgUrl: test,
          hieght: 250,
          width: 200,
        ),
        SizedBox(height:40),
      ],
    );
  }
}
