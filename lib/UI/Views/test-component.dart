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
import 'package:finance/UI/Componenets/form/dataList-form.dart';
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
        Alert(type: alertType.dark,content: Row(
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

        //btn
        //default
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [
          Btn(type:btnType.primary ,content: Txt('primary'),),
          Btn(type:btnType.secondary, content: Txt('secondary'),),
          Btn(type:btnType.success, content: Txt('success'),),
          Btn(type:btnType.danger, content: Txt('danger'),),
          Btn(type:btnType.warning, content: Txt('warning'),),
          Btn(type:btnType.info, content: Txt('info'),),
          Btn(type:btnType.light, content: Txt('light'),),
          Btn(type:btnType.dark, content: Txt('dark'),),
          Btn(type:btnType.link, content: Txt('link'),),
          Btn(type:btnType.dark, content: Txt('dark'), isCenter: true,),
        ],),
        //outline
        SizedBox(height: 30),
       Wrap(
         spacing: 5,
         runSpacing: 5,
         children: [
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
           Btn(type:btnType.link, content: Txt('link'),isOutline: true),
         ],
       ),

        //disable
        SizedBox(height: 30),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [
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
          ],
        ),

        SizedBox(height: 30),
        //disable and outline
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [
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
          ],
        ),

        SizedBox(height: 60),
        //toggle
        Btn(type: btnType.primary,content: Txt('primary'),isToggle: true , isActive: true,),
        Btn(type: btnType.primary,content: Txt('primary')),
        Btn(content: Txt('primary'),isToggle: true , isActive: true,),
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

        //end btn
        SizedBox(height: 30),

        //btn group
        //basic
        ButtonGroup(buttons: [
          ButtonItem(type: btnType.primary,contetnBtn: Txt('left', fontSize:16, fontWeight: FontWeight.w400,),),
          ButtonItem(type: btnType.primary,contetnBtn: Txt('middel', fontSize:16, fontWeight: FontWeight.w400,) ,),
          ButtonItem(type: btnType.primary , contetnBtn: Txt('right', fontSize:16, fontWeight: FontWeight.w400,)  , ),
        ],),
        SizedBox(height: 30),
        // acive
        ButtonGroup(buttons: [
          ButtonItem(type: btnType.success,contetnBtn: Txt('left', fontSize:16, fontWeight: FontWeight.w400,),isActive: true),
          ButtonItem(type: btnType.success,contetnBtn: Txt('middel', fontSize:16, fontWeight: FontWeight.w400,) ,),
          ButtonItem(type: btnType.primary , contetnBtn: Txt('right', fontSize:16, fontWeight: FontWeight.w400,)  , ),
        ],),
        SizedBox(height: 30),
        //mix
        ButtonGroup(buttons: [
          ButtonItem(type: btnType.danger,contetnBtn: Txt('left', fontSize:16, fontWeight: FontWeight.w400,),),
          ButtonItem(type: btnType.warning,contetnBtn: Txt('middel', fontSize:16, fontWeight: FontWeight.w400,) ,),
          ButtonItem(type: btnType.success , contetnBtn: Txt('right', fontSize:16, fontWeight: FontWeight.w400,)  , ),
        ],),
        SizedBox(height: 30),
        //outline
        ButtonGroup(buttons: [
          ButtonItem(type: btnType.dark ,contetnBtn: Txt('left', fontSize:16, fontWeight: FontWeight.w400,),isOutline: true,),
          ButtonItem(type: btnType.primary, contetnBtn: Txt('middel', fontSize:16, fontWeight: FontWeight.w400,) , isOutline: true),
          ButtonItem(type: btnType.primary , contetnBtn: Txt('right', fontSize:16, fontWeight: FontWeight.w400,) , isOutline: true),
        ],),
        SizedBox(height: 30),
        //checkbox
        ButtonGroup(buttons: [
          ButtonItem(type: btnType.primary ,contetnBtn: Txt('checkbox1', fontSize:16, fontWeight: FontWeight.w400,),isCheckBox: true ,  isOutline: true , isChechked: true ),
          ButtonItem(type: btnType.warning, contetnBtn: Txt('checkbox2', fontSize:16, fontWeight: FontWeight.w400,), isCheckBox: true , isOutline: true ,  isChechked: true),
          ButtonItem(type: btnType.primary , contetnBtn: Txt('checkbox3', fontSize:16, fontWeight: FontWeight.w400,) , isCheckBox: true , isOutline: true),
        ],),
        SizedBox(height: 30),
        //radio
        ButtonGroup(buttons: [
          ButtonItem(type: btnType.primary ,contetnBtn: Txt('radio1', fontSize:16, fontWeight: FontWeight.w400,), isRadio: true ,isOutline: true, isChechked: true),
          ButtonItem(type: btnType.warning, contetnBtn: Txt('radio2', fontSize:16, fontWeight: FontWeight.w400,),  isRadio: true  ,isOutline: true),
          ButtonItem(type: btnType.primary , contetnBtn: Txt('radio3', fontSize:16, fontWeight: FontWeight.w400,) ,  isRadio: true  , isOutline: true),
        ],),
        SizedBox(height: 30),
        //sizing
        ButtonGroup(buttons: [
          ButtonItem(type: btnType.secondary,contetnBtn: Txt('5', fontSize:16, fontWeight: FontWeight.w400,),isOutline: true),
          ButtonItem(type: btnType.secondary,contetnBtn: Txt('6', fontSize:16, fontWeight: FontWeight.w400,) ,isOutline: true),
          ButtonItem(type: btnType.secondary , contetnBtn: Txt('7', fontSize:16, fontWeight: FontWeight.w400,)  , isOutline: true),
        ],size: ButtonGroupSize.small),
        SizedBox(height: 30),
        ButtonGroup(buttons: [
          ButtonItem(type: btnType.secondary,contetnBtn: Txt('5', fontSize:16, fontWeight: FontWeight.w400,),isOutline: true),
          ButtonItem(type: btnType.secondary,contetnBtn: Txt('6', fontSize:16, fontWeight: FontWeight.w400,) ,isOutline: true),
          ButtonItem(type: btnType.secondary , contetnBtn: Txt('7', fontSize:16, fontWeight: FontWeight.w400,)  , isOutline: true),
        ],size: ButtonGroupSize.medium),
        SizedBox(height: 30),
        ButtonGroup(buttons: [
          ButtonItem(type: btnType.secondary,contetnBtn: Txt('5', fontSize:16, fontWeight: FontWeight.w400,),isOutline: true),
          ButtonItem(type: btnType.secondary,contetnBtn: Txt('6', fontSize:16, fontWeight: FontWeight.w400,) ,isOutline: true),
          ButtonItem(type: btnType.secondary , contetnBtn: Txt('7', fontSize:16, fontWeight: FontWeight.w400,)  , isOutline: true),
        ],size: ButtonGroupSize.large),
        SizedBox(height: 30),
        //Nesting
        ButtonGroup(
          buttons: [
          ButtonItem(type: btnType.primary,contetnBtn: Txt('1', fontSize:16, fontWeight: FontWeight.w400,),),
          ButtonItem(type: btnType.primary,contetnBtn: Txt('2', fontSize:16, fontWeight: FontWeight.w400,) ,),
          ButtonItem(type: btnType.primary  ,contetnBtn: Txt('right', fontSize:16, fontWeight: FontWeight.w400,)  ,
              isDropdown: true , contentBtnDropDown: 'DropDown' ,itemsDropDown: [DropdownItem(text: 'item1') , DropdownItem(text: 'item2')],isOutline: true),
        ],),
        SizedBox(height: 30),
        //vertical
        ButtonGroup(
          axis: ButtonGroupAxis.vertical,
          buttons: [
          ButtonItem(type: btnType.danger ,contetnBtn: Txt('radio1', fontSize:16, fontWeight: FontWeight.w400,), isRadio: true ,isOutline: true,),
          ButtonItem(type: btnType.danger, contetnBtn: Txt('radio2', fontSize:16, fontWeight: FontWeight.w400,),  isRadio: true  ,isOutline: true),
          ButtonItem(type: btnType.danger , contetnBtn: Txt('radio3', fontSize:16, fontWeight: FontWeight.w400,) ,  isRadio: true  , isOutline: true),
        ],),
        //end btn group


        //card

        //end card

        SizedBox(height: 30),
        //carousel slider
        //basic
        MyCarousel(items: [
          CarouselItem(
            imageUrl:  imgeTest,
          ),
          CarouselItem(
            imageUrl:  test,
            isActive: true

          ),
          CarouselItem(
            imageUrl:  loginSvg,

          ),
        ]),
        SizedBox(height: 30),
        //indicators
        MyCarousel(
          showIndicators: true,
            items: [
          CarouselItem(
            imageUrl:  imgeTest,
          ),
          CarouselItem(
              imageUrl:  test,

          ),
          CarouselItem(
            imageUrl:  loginSvg,
            isActive: true

          ),
        ]),
        SizedBox(height: 30),
        //captions
        MyCarousel(
            showIndicators: true,
            hasCaption: true,
            items: [
              CarouselItem(
                imageUrl:  imgeTest,
                caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),

              ),
              CarouselItem(
                imageUrl:  test,
                caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),

              ),
              CarouselItem(
                  imageUrl:  loginSvg,
                  isActive: true,
                caption:Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),

              ),
            ]),
        SizedBox(height: 30),
        //crossfade
        MyCarousel(
          isCrossFade: true,
            hasCaption: true,
            showIndicators: true,
            items: [
              CarouselItem(
                imageUrl:  imgeTest,
                caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),

              ),
              CarouselItem(
                imageUrl:  test,
                caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),

              ),
              CarouselItem(
                imageUrl:  loginSvg,
                isActive: true,
                caption:Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),

              ),
            ]),
        SizedBox(height: 30),
        //autoplaying
        MyCarousel(
            isAutoPlay: true,
            showIndicators: true,
            items: [
          CarouselItem(
            imageUrl:  imgeTest,
          ),
          CarouselItem(
              imageUrl:  test,
              isActive: true

          ),
          CarouselItem(
            imageUrl:  loginSvg,

          ),
        ]),
        SizedBox(height: 30),
        //ride
        MyCarousel(
            ride: true,
            showIndicators: true,
            items: [
              CarouselItem(
                imageUrl:  imgeTest,
              ),
              CarouselItem(
                  imageUrl:  test,
                  isActive: true

              ),
              CarouselItem(
                imageUrl:  loginSvg,

              ),
            ]),
        SizedBox(height: 30),
        //Individual .carousel-item interval
        MyCarousel(
          items: [
          CarouselItem(
            imageUrl:  imgeTest,
            caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
            autoPlayInterval: Duration(milliseconds: 10000),
          ),
          CarouselItem(
            imageUrl:  test,
            caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
            autoPlayInterval: Duration(milliseconds: 2000),
          ),
          CarouselItem(
            imageUrl:  loginSvg,
            caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
          ),
        ] , isAutoPlay: true , hasCaption: true,),
        SizedBox(height: 30),
        //Autoplaying carousels without controls
        MyCarousel(
          hasControl: true,
          items: [
            CarouselItem(
              imageUrl:  imgeTest,
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
          ] , isAutoPlay: true , hasCaption: true,),
        SizedBox(height: 30),
        //Disable touch swiping
        MyCarousel(
           hasTouchSwipping: false,
          items: [
            CarouselItem(
              imageUrl:  imgeTest,
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
          ] , isAutoPlay: true , hasCaption: true,),
        SizedBox(height: 30),
        //isDark
        MyCarousel(
            items: [
          CarouselItem(
            imageUrl:  imgeTest,
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
        //cros fade by autoplay
        MyCarousel(
          items: [
            CarouselItem(
              imageUrl:  imgeTest,
              caption:Caption(header: "عنوان 1", body: "توضیحات مربوط به تصویر اول"),
              autoPlayInterval: Duration(milliseconds: 10000),
            ),
            CarouselItem(
              imageUrl:  test,
              caption:Caption(header: "عنوان 2", body: "توضیحات مربوط به تصویر دوم"),
              autoPlayInterval: Duration(milliseconds: 2000),
            ),
            CarouselItem(
              imageUrl:  loginSvg,
              caption: Caption(header: "عنوان 3", body: "توضیحات مربوط به تصویر سوم"),
            ),
          ] , isAutoPlay: true , hasCaption: true,isCrossFade: true),
        //end carousel slider

        SizedBox(height: 60),

        //close-btn
        //basic
        CloseBtn(onClose: (){}),
        SizedBox(height: 30),
        //disable
        CloseBtn(onClose: (){} , isDisabled: true),
        SizedBox(height: 30),
        //dark
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: dark,
          ),
          child: Row(
            children: [
              CloseBtn(onClose: (){},),
              SizedBox(width: 10,),
              CloseBtn(onClose: (){} , isDisabled: true),
            ],
          ),
        ),
        //end close-btn

        SizedBox(height: 60),

        //collpse
        //basic
        Collapse(type: btnType.primary,btnContent: Txt('Link with href') , content: 'Some placeholder content for the collapse component. This panel is hidden by default but revealed when the user activates the relevant trigger.',),
        SizedBox(height: 30),
        //Horizental
        Collapse(type: btnType.primary,btnContent: Txt('Link with href') , content: 'Some placeholder content for the collapse component. This panel is hidden by default but revealed when the user activates the relevant trigger.',isHorizontal: true),
        SizedBox(height: 30),
        //Multiple toggles and targets
        MultiCollapse(
          buttons: [
            Collapse(
              type: btnType.primary,
              btnContent: Txt("Toggle first element"),
              targetId: "collapse1",
            ),
            Collapse(
              type: btnType.primary,
              btnContent: Txt("Toggle second element"),
              targetId: "collapse2",
            ),
            Collapse(
              type: btnType.primary,
              btnContent: Txt("Toggle both elements"),
              targetIds: ["collapse1", "collapse2"],
            ),
          ],
          collapsibles: [
            Collapse(
              type: btnType.primary,
              targetId: "collapse1",
              content: "Content for first collapse",
            ),
            Collapse(
              type: btnType.primary,
              targetId: "collapse2",
              content: "Content for second collapse",
            ),
          ],
        ),
        //end collapse
        SizedBox(height: 60),
        DataListInput(options: ['aaaaaa' , 'vvvvv' , 'kkkk'] , label: 'xxxx' , ),
        SizedBox(height: 30),





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
