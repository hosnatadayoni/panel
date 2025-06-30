import 'package:finance/Admin/Public/images.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/img.dart';
import 'package:finance/Admin/UI/Componenets/General/myDivider.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/accordion.dart';
import 'package:finance/Admin/UI/Componenets/alert.dart';
import 'package:finance/Admin/UI/Componenets/alert.dart';
import 'package:finance/Admin/UI/Componenets/badge.dart';
import 'package:finance/Admin/UI/Componenets/breadCrumb.dart';
import 'package:finance/Admin/UI/Componenets/btn-group/btn-group-item.dart';
import 'package:finance/Admin/UI/Componenets/btn-group/btn-group.dart';
import 'package:finance/Admin/UI/Componenets/btn.dart';
import 'package:finance/Admin/UI/Componenets/card.dart';
import 'package:finance/Admin/UI/Componenets/carousel-slider.dart';
import 'package:finance/Admin/UI/Componenets/close-btn.dart';
import 'package:finance/Admin/UI/Componenets/collapse.dart';
import 'package:finance/Admin/UI/Componenets/dissmisiable-alert.dart';
import 'package:finance/Admin/UI/Componenets/dropDown/drop-down-item.dart';
import 'package:finance/Admin/UI/Componenets/dropDown/drop-down.dart';
import 'package:finance/Admin/UI/Componenets/form.dart';
import 'package:finance/Admin/UI/Componenets/form/checkbox-form.dart';
import 'package:finance/Admin/UI/Componenets/form/dataList-form.dart';
import 'package:finance/Admin/UI/Componenets/form/file-form.dart';
import 'package:finance/Admin/UI/Componenets/form/input-form.dart';
import 'package:finance/Admin/UI/Componenets/form/input-group-form.dart';
import 'package:finance/Admin/UI/Componenets/form/radioButton-form.dart';
import 'package:finance/Admin/UI/Componenets/form/select-form.dart';
import 'package:finance/Admin/UI/Componenets/form/input-group-form2.dart';
import 'package:finance/Admin/UI/Componenets/modal.dart';
import 'package:finance/Admin/UI/Componenets/placeholder/btn-placeholder.dart';
import 'package:finance/Admin/UI/Componenets/placeholder/content-placeholder.dart';
import 'package:finance/Admin/UI/Componenets/placeholder/img-placeholder.dart';
import 'package:finance/Admin/UI/Componenets/popOvers.dart';
import 'package:finance/Admin/UI/Componenets/progress/progress-item.dart';
import 'package:finance/Admin/UI/Componenets/progress/progress.dart';
import 'package:finance/Admin/UI/Componenets/spinner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../Componenets/form/color-form.dart';
import '../Componenets/form/range-form.dart';
import '../Componenets/form/switch-form.dart';
import '../Componenets/form/switch-box.dart';
import '../Componenets/tooltip.dart';

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
        Btn(type: btnType.primary,content: Txt('primary'),isToggle: true , isActive: true,),
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

        //card
        //body
        CustomCard(
          body: Txt('This is some text within a card body.', fontSize: 16, fontWeight: FontWeight.w400,),
        ),
        SizedBox(height: 30),
        //Titles, text, and links
        CustomCard(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Txt('card title' , fontSize: 20, fontWeight: FontWeight.w500,color: dark,),
                SizedBox(height: 5,),
                Txt('card subtitle' , fontSize: 16, fontWeight: FontWeight.w500,color: secondry,),
                SizedBox(height: 10,),
                Txt('This is some text within a card body.' , fontSize: 16, fontWeight: FontWeight.w400, color: dark,),
                SizedBox(height: 20,),
                Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: [
                    InkWell(
                        onTap: () {
                        },
                        child: Txt('Card Link' , fontSize: 16, fontWeight: FontWeight.w400,textDecoration: TextDecoration.underline , color: Colors.blue,)),
                    InkWell(
                        onTap: () {
                        },
                        child: Txt('Another link' , fontSize: 16, fontWeight: FontWeight.w400,textDecoration: TextDecoration.underline , color: Colors.blue,)),
                  ],
                )
              ],
            )
        ),
        SizedBox(height: 30),
        //images
        CustomCard(
            padding: 0,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                    child: Img(imgeTest,width: size.width ,height: 180,)),
                SizedBox(height: 10,),
                Container(
                    padding: EdgeInsets.all(16),
                    child: Txt('Some quick example text to build on the card title and make up the bulk of the card’s content.' , fontSize: 16, fontWeight: FontWeight.w400,)),
              ],
            )
        ),
        SizedBox(height: 30),
        //list groups
        CustomCard(
            padding: 0,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                    child: Txt('An item', fontSize: 16, fontWeight: FontWeight.w400, color: dark,)),
                MyDivider(),
                Container(
                    padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                    child: Txt('A second item' , fontSize: 16, fontWeight: FontWeight.w400, color: dark,)),
                MyDivider(),
                Container(
                    padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                    child: Txt('A third item' , fontSize: 16, fontWeight: FontWeight.w400, color: dark,)),
              ],
            )
        ),
        SizedBox(height: 30),
        //list group and header
        CustomCard(
          padding: 0,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                  child: Txt('An item', fontSize: 16, fontWeight: FontWeight.w400, color: dark,)),
              MyDivider(),
              Container(
                  padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                  child: Txt('A second item' , fontSize: 16, fontWeight: FontWeight.w400, color: dark,)),
              MyDivider(),
              Container(
                  padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                  child: Txt('A third item' , fontSize: 16, fontWeight: FontWeight.w400, color: dark,)),
            ],
          ),
          cardHeader: 'Feature',
        ),
        SizedBox(height: 30),
        //list group and footer
        CustomCard(
          padding: 0,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                  child: Txt('An item', fontSize: 16, fontWeight: FontWeight.w400, color: dark,)),
              MyDivider(),
              Container(
                  padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                  child: Txt('A second item' , fontSize: 16, fontWeight: FontWeight.w400, color: dark,)),
              MyDivider(),
              Container(
                  padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                  child: Txt('A third item' , fontSize: 16, fontWeight: FontWeight.w400, color: dark,)),
            ],
          ),
          cardFooter: 'Card Footer',
        ),
        SizedBox(height: 30),
        //Kitchen sink
        CustomCard(
            padding: 0,
            width: 400,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                    child: Img(imgeTest,width: size.width ,height: 180,)),
                SizedBox(height: 10,),
                Container(
                    padding: EdgeInsets.only(right: 16),
                    child: Txt('card title' , fontSize: 20, fontWeight: FontWeight.w500,color: dark,)),
                SizedBox(height: 5,),
                Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Txt('card subtitle' , fontSize: 16, fontWeight: FontWeight.w500,color: secondry,),),
                SizedBox(height: 10,),
                Container(
                    padding: EdgeInsets.only(right: 16),
                    child: Txt('This is some text within a card body.' , fontSize: 16, fontWeight: FontWeight.w400, color: dark,)),
                SizedBox(height: 20,),
                MyDivider(),
                Container(
                    padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                    child: Txt('An item', fontSize: 16, fontWeight: FontWeight.w400, color: dark,)),
                MyDivider(),
                Container(
                    padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                    child: Txt('A second item' , fontSize: 16, fontWeight: FontWeight.w400, color: dark,)),
                MyDivider(),
                Container(
                    padding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left: 16),
                    child: Txt('A third item' , fontSize: 16, fontWeight: FontWeight.w400, color: dark,)),
                MyDivider(),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 5,
                    children: [
                      InkWell(
                          onTap: () {
                          },
                          child: Txt('Card Link' , fontSize: 16, fontWeight: FontWeight.w400,textDecoration: TextDecoration.underline , color: Colors.blue,)),
                      InkWell(
                          onTap: () {
                          },
                          child: Txt('Another link' , fontSize: 16, fontWeight: FontWeight.w400,textDecoration: TextDecoration.underline , color: Colors.blue,)),
                    ],
                  ),
                )
              ],
            )
        ),
        SizedBox(height: 30),
        //Image overlays
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
          imageOverlay: true,
          imgUrl: test,
          hieght: 250,
          width: 200,
        ),
        //end card

        SizedBox(height: 60),

        //dropDown
        //basic
        Dropdown(type: btnType.warning,dropDownTitle: 'DropDown', itemsDropDown: [DropdownItem(text: "Action"),
          DropdownItem(text: "Another action"),
          DropdownItem(text: "Something else here"),],
            spreadLinkList:['spread link']
        ),
        SizedBox(height: 30),
        //Split button
        Dropdown(type: btnType.warning,dropDownTitle: 'DropDown', itemsDropDown: [DropdownItem(text: "Action"),
          DropdownItem(text: "Another action"),
          DropdownItem(text: "Something else here"),],
          spreadLinkList:['spread link'],
          isSplitButton: true,
        ),
        SizedBox(height: 30),
        //sizing
        Dropdown(type: btnType.warning,dropDownTitle: 'DropDown', itemsDropDown: [DropdownItem(text: "Action"),
          DropdownItem(text: "Another action"),
          DropdownItem(text: "Something else here"),],
          spreadLinkList:['spread link'],
          isSplitButton: true,
          size: DropDownSize.small,
        ),
        SizedBox(height: 5),
        Dropdown(type: btnType.warning,dropDownTitle: 'DropDown', itemsDropDown: [DropdownItem(text: "Action"),
          DropdownItem(text: "Another action"),
          DropdownItem(text: "Something else here"),],
          spreadLinkList:['spread link'],
          isSplitButton: true,
          size: DropDownSize.large,
        ),
        SizedBox(height: 5),
        Dropdown(type: btnType.warning,dropDownTitle: 'DropDown', itemsDropDown: [DropdownItem(text: "Action"),
          DropdownItem(text: "Another action"),
          DropdownItem(text: "Something else here"),],
          spreadLinkList:['spread link'],
          isSplitButton: true,
          size: DropDownSize.medium,
        ),
        SizedBox(height: 30),
        //dark dropdown
        Dropdown(type: btnType.secondary,dropDownTitle: 'dark button' , itemsDropDown: [
          DropdownItem(text: "Action", isActive: true),
          DropdownItem(text: "Another action"),
          DropdownItem(text: "Something else here"),
        ],spreadLinkList:['spread link'] , ColorDropDownBox: color34 , ColorTitleDropDownBox: color5,ColorHoverBox: color41),
        SizedBox(height: 30),
        //dropdown-item-text
        Dropdown(
            itemsDropDown: [
              DropdownItem(text: "Dropdown item text", isInteractive: false),
              DropdownItem(text: "Action", value: "action"),
              DropdownItem(text: "Another action", value: "another_action"),
              DropdownItem(text: "Something else here", value: "something_else"),
            ], dropDownTitle: 'dropDownItemText',type: btnType.primary
        ),
        SizedBox(height: 30),
        //active
        Dropdown(
          type: btnType.primary,
          itemsDropDown: [
            DropdownItem(text: "Dropdown item text"),
            DropdownItem(text: "Action", value: "action"),
            DropdownItem(text: "Another action", value: "another_action" , isActive: true),
            DropdownItem(text: "Something else here", value: "something_else"),
          ], dropDownTitle: 'active item',
        ),
        SizedBox(height: 30),
        //Disabled
        Dropdown(
          type: btnType.primary,
          itemsDropDown: [
            DropdownItem(text: "Dropdown item text"),
            DropdownItem(text: "Action", value: "action"),
            DropdownItem(text: "Another action", value: "another_action" ,isDisabled: true),
            DropdownItem(text: "Something else here", value: "something_else"),
          ], dropDownTitle: 'disabled item',
        ),
        SizedBox(height: 30),
        //headers
        Dropdown(
          type: btnType.primary,
          itemsDropDown: [
            DropdownItem(text: "Dropdown item text", isHeader: true ),
            DropdownItem(text: "Action", value: "action"),
            DropdownItem(text: "Another action", value: "another_action"),
            DropdownItem(text: "Something else here", value: "something_else"),
          ], dropDownTitle: 'Headers item',
        ),
        //end dropDown


        SizedBox(height: 60),

        //placeholder
        //basic
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
                    ContentPlaceholder(width: 180,),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10,),
            ButtonPlaceholder(type: btnType.success,width: 200,height: 40,)

          ],
        ),
        SizedBox(height: 30),
        //end placeholder

        SizedBox(height: 60),

        //popOvers
        //basic and direction
        PopOverWidget(type: btnType.danger,content: Txt('Click to toggle popover'), popOverBody: 'And here’s some amazing content. It’s very engaging. Right?',direction: d.top, size: ButtonSize.medium, ),
        PopOverWidget(type: btnType.danger,content: Txt('Click to toggle popover'), popOverBody: 'And here’s some amazing content. It’s very engaging. Right?',direction: d.top, size: ButtonSize.large, ),
        SizedBox(height: 30),
        //disable
        PopOverWidget(type: btnType.danger,content: Txt('Click to disable toggle popover'), popOverBody: 'And here’s some amazing content. It’s very engaging. Right?',direction: d.top, size: ButtonSize.large,disabled: true, ),
        //end popOvers

        SizedBox(height: 60),

        //progress
        MultiColorProgressBar(items: [
          ProgressItem(
              value: 25,
              // hasStriped: true,
              showLabel: true,
              type: btnType.primary
          ),
          ProgressItem(
              value: 50,
              showLabel: true,
              type: btnType.success
          ),
          ProgressItem(
              value: 10,
              showLabel: true,
              type: btnType.info
          ),
          ProgressItem(
              value: 15,
              showLabel: true,
              type: btnType.warning
          ),
        ],),
        //end progress

        SizedBox(height: 60),

        //spinners
        Spinner(typeSpinner: btnType.info,alignment: SpinnerAlignment.end),
        SizedBox(height: 30),
        //growing spinner
        Spinner(typeSpinner: btnType.info,type: SpinnerType.grow, alignment: SpinnerAlignment.center),
        SizedBox(height: 30),
        //buttons
        Btn(type:btnType.primary , disabled: true,content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Spinner(typeSpinner: btnType.info,  type: SpinnerType.grow, size: 15,),
          ],
        ),),
        //end spinners


        SizedBox(height: 60),

        //tooltip
        TooltipWidget(btn: Btn(type: btnType.primary,content: Txt('button')) , content: Txt('This top tooltip is themed via CSS variables.'), direction: TooltipDirection.up),
        //end tooltip

        SizedBox(height: 60),

        //modal
        //basic
        CustomModal(header: Txt('ssss'),body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,), contetnBtn: Txt('Launch demo modal'),type: btnType.primary),
        SizedBox(height: 30),
        //Static backdrop
        CustomModal(header: Txt('ssss'),body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,), contetnBtn: Txt('Launch demo modal'),type: btnType.primary,staticBackdrop: true),
        SizedBox(height: 30),
        //Scrolling long content
        CustomModal(header: Txt('ssss'),body: Txt('Where can I get some There are many variations of passages of Lorem Ipsum available, but '
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
          contetnBtn: Txt('Scrolling long content'),type: btnType.primary,),
        SizedBox(height: 30),
        //vertically center
        CustomModal(header: Txt('ssss'),body: Txt('jjjjjjjjjjjjjjjj'
            'Various versions have evol' , fontSize: 16, fontWeight: FontWeight.w400,),contetnBtn: Txt('Vertically centered modal'),type: btnType.primary,isModalDialogCenter: true),
        SizedBox(height:30),
        CustomModal(header: Txt('ssss'),body: Txt('Where can I get some There are many variations of passages of Lorem Ipsum available, but '
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
            'Various versions have evol' , fontSize: 16, fontWeight: FontWeight.w400,),contetnBtn: Txt('Vertically centered scrollable modal'),type: btnType.primary ,isModalDialogCenter: true),
        SizedBox(height:30),
        //sizes
        CustomModal(header: Txt('ssss'),body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),contetnBtn: Txt('Small Modal'),type: btnType.primary,modalSize: ModalSize.small),
        SizedBox(height:30),
        CustomModal(header: Txt('ssss'),body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),contetnBtn: Txt('Default Modal'),type: btnType.primary),
        SizedBox(height:30),
        CustomModal(header: Txt('ssss'),body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),contetnBtn: Txt('Large Modal'),type: btnType.primary,modalSize: ModalSize.large),
        SizedBox(height:30),
        CustomModal(header: Txt('ssss'),body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),contetnBtn: Txt('Extra Large Modal'),type: btnType.primary, modalSize: ModalSize.xlarge),
        SizedBox(height:30),


        //fullscrenn responsive
        CustomModal(header: Txt('ssss'),body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),contetnBtn: Txt('Full Screen'),type: btnType.primary , modalSize: ModalSize.fullScreen),
        SizedBox(height:30),
        CustomModal(header: Txt('ssss'),body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),contetnBtn: Txt('Full screen below sm'),type: btnType.primary , modalFullscreenMode: ModalFullscreenMode.smDown),
        SizedBox(height:40),
        CustomModal(header: Txt('ssss'),body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),contetnBtn: Txt('Full screen below md'),type: btnType.primary , modalFullscreenMode: ModalFullscreenMode.mdDown),
        SizedBox(height:40),
        CustomModal(header: Txt('ssss'),body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),contetnBtn: Txt('Full screen below lg'),type: btnType.primary , modalFullscreenMode: ModalFullscreenMode.lgDown),
        SizedBox(height:40),
        CustomModal(header: Txt('ssss'),body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),contetnBtn: Txt('Full screen below xl'),type: btnType.primary , modalFullscreenMode: ModalFullscreenMode.xlDown),
        SizedBox(height:40),
        CustomModal(header: Txt('ssss'),body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),contetnBtn: Txt('Full screen below xxl'),type: btnType.primary , modalFullscreenMode: ModalFullscreenMode.xxlDown),
        //end modal


        SizedBox(height: 60),
        //form
        //email
        InputForm(lableText: 'Email Address', keyBoardType: keyboardType.email ,formText: 'Well never share your email with anyone else.'),
        SizedBox(height: 30),
        InputForm(lableText: 'Password', keyBoardType: keyboardType.password ,),
        SizedBox(height: 30),
        CheckBoxForm(text: 'Check me out' ,),
        SizedBox(height: 30),
        //disable
        InputForm(lableText: 'Disabled input', keyBoardType: keyboardType.password , disabled: true,),
        SizedBox(height: 30),
        CheckBoxForm(text: 'can not Check me out' , disabled: true),
        SizedBox(height: 30),
        Btn(type: btnType.primary , content: Txt('submit'),disabled: true,),
        SizedBox(height: 30),
        InputForm(lableText: 'Example textarea', fieldType: FieldType.textarea,),
        SizedBox(height: 30),
        //sizing
        InputForm(size: InputSize.small,),
        SizedBox(height: 30),
        InputForm(size: InputSize.large,),
        SizedBox(height: 30),
        InputForm(size: InputSize.medium,),
        SizedBox(height: 30),
        InputForm(lableText: 'Password', keyBoardType: keyboardType.password ,
            formText: 'Your password must be 8-20 characters long, contain letters and numbers, and must not contain spaces, special characters, or emoji.'),
        SizedBox(height: 30),
        InputForm(lableText: 'Password', keyBoardType: keyboardType.password ,
            formText: 'st not contain spaces, special characters, or emoji.', layoutDirection: direction.horizontal),
        //disabled
        SizedBox(height: 30),
        InputForm(lableText: 'disabled input',disabled: true,),
        SizedBox(height: 30),
        //Disabled readonly input
        InputForm(lableText: 'Disabled readonly input',readOnly: true, disabled: true, ),
        SizedBox(height: 30),
        //read only
        InputForm(lableText: 'readonly input here...',readOnly: true, ),
        SizedBox(height: 30),
        //Readonly plain text
        InputForm(lableText: 'readonly input here...',readOnly: true,isPlainTxt: true,hintText: 'email@example.com',),
        SizedBox(height: 30),
        Row(
          children: [
            Expanded(child: InputForm(readOnly: true,isPlainTxt: true,hintText: 'email@example.com',)),
            SizedBox(width: 5,),
            Expanded(child:InputForm(keyBoardType: keyboardType.password , hintText: 'password',),)

          ],
        ),
        SizedBox(height: 30),
        //File input
        FileForm(lable: 'Default file input example'),
        SizedBox(height: 30),
        FileForm(lable: 'Disabled file input example' , disabled: true),
        //end File input
        SizedBox(height: 30),
        //size
        FileForm(lable: 'Small file input example' ,size: InputSize.small),
        SizedBox(height: 30),
        FileForm(lable: 'Large file input example' ,size: InputSize.large),
        //end size
        SizedBox(height: 30),
        //Color
        ColorPickerBox(selectedColor: Colors.blue),
        //end color
        SizedBox(height: 30),
        //dataLists
        DataListInput(options: ['aaaaaa' , 'vvvvv' , 'kkkk'] , label: 'xxxx' , ),
        //end dataLists
        SizedBox(height: 30),
        //select
        //end select
        CustomSelect(
          hintText: 'Open this select menu',
          selectedValue: '0',
          items: const [
            DropdownMenuItem(value: '0', child: Text('Open this select menu')),
            DropdownMenuItem(value: '1', child: Text('One')),
            DropdownMenuItem(value: '2', child: Text('Two')),
            DropdownMenuItem(value: '3', child: Text('Three')),
          ],
          onChanged: (value) {

          },
        ),
        SizedBox(height: 30),
        //size
        CustomSelect(
          hintText: 'Open this select menu',
          items: const [
            DropdownMenuItem(value: '1', child: Text('One')),
            DropdownMenuItem(value: '2', child: Text('Two')),
            DropdownMenuItem(value: '3', child: Text('Three')),
          ],
          onChanged: (value) {

          },
          size: InputSize.large,
        ),
        SizedBox(height: 30),
        CustomSelect(
          hintText: 'Open this select menu',
          items: const [
            DropdownMenuItem(value: '1', child: Text('One'),),
            DropdownMenuItem(value: '2', child: Text('Two')),
            DropdownMenuItem(value: '3', child: Text('Three'),),
          ],
          onChanged: (value) {

          },
          size: InputSize.small,
        ),
        SizedBox(height: 30),
        //disabled
        CustomSelect(
          hintText: 'Open this select menu',
          items: const [
            DropdownMenuItem(value: '1', child: Text('One'),),
            DropdownMenuItem(value: '2', child: Text('Two')),
            DropdownMenuItem(value: '3', child: Text('Three'),),
          ],
          onChanged: (value) {

          },
          disabled: true,
        ),
        SizedBox(height: 30),

        //checkes and radio and switch
        //checkes
        CheckBoxForm(text: 'Default checkbox' ,),
        SizedBox(height: 30),
        CheckBoxForm(text: 'Checked checkbox' , checked: true),
        SizedBox(height: 30),
        CheckBoxForm(text: 'Disabled checkbox' , disabled: true,),
        SizedBox(height: 30),
        CheckBoxForm(text: 'Disabled Checked checkbox' , disabled: true, checked: true,),
        SizedBox(height: 30),
        //radios
        RadioButton(items: [RadioItem(text: 'Default radio'  , ) , RadioItem(text: 'Default Checked radio' , checked: true)],onChanged: (d){}),
        SizedBox(height: 30),
        //disabled
        RadioButton(items: [RadioItem(text: 'Disabled radio'  , disabled: true) , RadioItem(text: 'Disabled Checked radio' , checked: true , disabled: true ,)],onChanged: (d){}),
        SizedBox(height: 30),
        //switchs
        SwitchBox(label: 'Default switch checkbox input',),
        SizedBox(height: 30),
        SwitchBox(label: 'Checked switch checkbox input', checked: true,),
        SizedBox(height: 30),
        SwitchBox(label: 'Disabled switch checkbox input', disabled: true,),
        SizedBox(height: 30),
        SwitchBox(label: 'Disabled checked switch checkbox input', disabled: true, checked: true,),
        //end  checkes and radio and switch
        SizedBox(height: 30),

        //rang
        CustomRangeSlider(
          label: "Example range",
          min: 0,
          max: 100,
          onChanged: (value) {
          },
        ),
        SizedBox(height: 30),
        //disabled
        CustomRangeSlider(
          label: "Example range",
          min: 0,
          max: 100,
          disabled: true,
          onChanged: (value) {
          },
        ),
        SizedBox(height: 30),
        //steps
        CustomRangeSlider(
          label: "Example range",
          min: 0,
          max: 100,
          step: 5,
          onChanged: (value) {
          },
        ),
        //end range

        //input group
        SizedBox(height: 30),
        InputGroup(inputs: [InputForm(hintText: 'نام',inputWidth: 500,),],prefixIcons: [Container(
          width: 40,
          height: 40,
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
              color: color38,
              border: Border.all(width: 1 , color: color5),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              )
          ),
          child: Center(
            child: Txt('@' , fontSize:14 ,),
          ),
        )] , formTxt: 'Example help text goes outside the input group.'),
        SizedBox(height: 30),
        InputGroup(inputs: [InputForm(hintText: 'نام',inputWidth: 500,),],
          prefixIcons: [Container(
              width: 46,
              height: 40,
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                  color: color38,
                  border: Border.all(width: 1 , color: color5),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  )
              ),child: Center(child: Txt('00.' , fontSize:14 ,)))] ,
          suffixIcons: [Container(
              width: 40,
              height:40,
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                  color: color38,
                  border: Border.all(width: 1 , color: color5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  )
              ),child: Center(child: Txt('@' , fontSize:14 ,)))],),
        SizedBox(height: 30),
        InputGroup(
          inputs: [
            InputForm(
              hintText: 'Username',
              borderColor: Colors.grey,
              borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight:Radius.circular(5) , ),
              inputWidth: 500,
            ),
            Container(

              padding: EdgeInsets.only(top: 6 , bottom:  6 , left: 12 , right: 12),
              decoration: BoxDecoration(
                color: color38,
                border: Border.all(width: 1 , color: color5),

              ),
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Txt('@', fontSize: 16),
              ),

            ),
            InputForm(
              hintText: 'Server',
              borderColor: Colors.grey,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft:Radius.circular(5) , ),
              inputWidth: 500,
            ),
          ],
        ),
        SizedBox(height: 30),
        //textarea
        InputGroup(inputs: [InputForm(hintText: 'نام',fieldType: FieldType.textarea , inputWidth: 500,),],
          suffixIcons: [Container(
              width: 120,
              height: 94,
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                  color: color38,
                  border: Border.all(width: 1 , color: color5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  )
              ),child: Center(child: Txt('with textarea' , fontSize:14 ,)))],),
        SizedBox(height: 30),
        //wrapping

        SizedBox(height: 30),
        //size
        InputGroup(inputs: [InputForm(hintText: 'نام',size: InputSize.small,inputWidth: 500,),] ,
          suffixIcons: [Container(
              width: 40,
              height: 40,
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                  color: color38,
                  border: Border.all(width: 1 , color: color5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  )),child: Center(child: Txt('@' , fontSize:14 ,)))],size: InputSize.small,),
        SizedBox(height: 30),
        InputGroup(inputs: [InputForm(hintText: 'نام',size: InputSize.medium,inputWidth: 500,),] , suffixIcons: [Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
                color: color38,
                border: Border.all(width: 1 , color: color5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                )),child: Center(child: Txt('@' , fontSize:14 ,)))],size: InputSize.medium,),
        SizedBox(height: 30),
        InputGroup(inputs: [InputForm(hintText: 'نام',size: InputSize.large,inputWidth: 500,),] , suffixIcons: [Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
                color: color38,
                border: Border.all(width: 1 , color: color5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                )),child: Center(child: Txt('@' , fontSize:14 ,)))],size: InputSize.large,),
        //end size
        SizedBox(height: 30),
        //radios
        InputGroup(inputs: [InputForm(hintText: 'نام',inputWidth: 500,),] , suffixIcons: [Container(
            width: 42,
            height: 40,
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
                color: color38,
                border: Border.all(width: 1 , color: color5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                )
            ),

            child: Center(child: RadioButton(items: [RadioItem(text: '')],mainAxisAlignment: MainAxisAlignment.center,)))],),
        SizedBox(height: 30),
        //Checkboxes
        InputGroup(inputs: [InputForm(hintText: 'نام',inputWidth: 500,),] , suffixIcons: [Container(
            width: 42,
            height:40,
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
                color: color38,
                border: Border.all(width: 1 , color: color5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                )
            ),
            child: CheckBoxForm())]),
        SizedBox(height: 30),
        //Multiple inputs
        InputGroup(inputs: [InputForm(hintText: 'نام',inputWidth: 500,borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))), InputForm(hintText: 'نام خانوادگی',),],
            suffixIcons: [Container(
                width: 160,
                height:40,
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                    color: color38,
                    border: Border.all(width: 1 , color: color5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    )
                ),child: Center(child: Txt('First and last name' , fontSize:14 ,)))], isWrap: false),
        SizedBox(height: 30),
        //Multiple addons
        InputGroup(inputs: [InputForm(hintText: 'نام',inputWidth: 500,)],
            suffixIcons: [Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: color38,
                  border: Border.all(width: 1 , color: color5),
                ),child: Center(child: Txt('@' , fontSize:14 ,))) , Container(
                width: 58,
                height:40,
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                    color: color38,
                    border: Border.all(width: 1 , color: color5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    )
                ),child: Center(child: Txt('0.00' , fontSize:14 ,)))]),
        InputGroup(inputs: [InputForm(hintText: 'نام',inputWidth: 500,)],prefixIcons: [
          Container(padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              width: 40,
              height:40,
              decoration: BoxDecoration(
                  color: color38,
                  border: Border.all(width: 1 , color: color5),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  )
              ),child: Center(child: Txt('@' , fontSize:14 ,))) , Container(
              width: 58,
              height: 40,
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: color38,
                border: Border.all(width: 1 , color: color5),
              ),child: Center(child: Txt('0.00' , fontSize:14 ,)))]),
        SizedBox(height: 30),
        //Button addons
        InputGroup(inputs: [InputForm(hintText: 'نام',inputWidth: 500,),] ,
            suffixIcons: [Btn(type: btnType.secondary , isOutline: true, content: Txt('button'),
              borderRadius: BorderRadius.only(topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0) , topLeft:Radius.circular(5) , bottomLeft:Radius.circular(5) ),)]),
        SizedBox(height: 30),
        //Buttons with dropdowns
        InputGroup(inputs: [InputForm(hintText: 'نام',inputWidth: 500,),] ,
          suffixIcons: [Dropdown(type: btnType.secondary , isOutline: true,dropDownTitle: 'DropDown',itemsDropDown: [
            DropdownItem(text: "Action"),
            DropdownItem(text: "Another action"),
            DropdownItem(text: "Something else here"),
          ],
              spreadLinkList:['spread link'],dropDownTitelColor: Colors.grey ,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5),
                  bottomLeft:Radius.circular(5) )),],),
        SizedBox(height: 30),
        //Segmented buttons
        InputGroup(inputs: [InputForm(hintText: 'نام' , inputWidth: 500,),] ,
          suffixIcons: [Dropdown(type: btnType.secondary , isOutline: true,dropDownTitle: 'DropDown',itemsDropDown: [
            DropdownItem(text: "Action"),
            DropdownItem(text: "Another action"),
            DropdownItem(text: "Something else here"),
          ],
              spreadLinkList:['spread link'],dropDownTitelColor: Colors.grey ,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5),
                  bottomLeft:Radius.circular(5) ), isSplitButton: true ,
              borderRadiusSplitBtn: BorderRadius.only(topRight: Radius.circular(0),
                bottomRight:Radius.circular(0),)),],),
        SizedBox(height: 30),
        //Custom select
        InputGroup(inputs: [CustomSelect(hintText: 'choose...',
          borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
          onChanged: (value) {},
          width: 800,
          items:  [
            DropdownMenuItem(value: '1', child: Text('One')),
            DropdownMenuItem(value: '2', child: Text('Two')),
            DropdownMenuItem(value: '3', child: Text('Three')),

          ],)],
            suffixIcons: [Btn(type: btnType.secondary , isOutline: true, content: Txt('button'),
                borderRadius: BorderRadius.only(topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0) , topLeft:Radius.circular(5) , bottomLeft:Radius.circular(5)))]),
        SizedBox(height: 30),
        //Custom file input
        InputGroup(inputs: [FileForm(borderRadius:  BorderRadius.only(
          topLeft: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(5),

        ),width: 500,)],
            suffixIcons: [Container(
                width: 77,
                height:40,
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                    color: color38,
                    border: Border.all(width: 1 , color: color5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    )
                ),child: Center(child: Txt('Upload' , fontSize:14 ,)))]),
        InputGroup(inputs: [FileForm(borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(5),

        ),width: 500,)],
            suffixIcons: [Btn(type: btnType.secondary , isOutline: true, content: Txt('button'),
              borderRadius: BorderRadius.only(topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0) , topLeft:Radius.circular(5) , bottomLeft:Radius.circular(5) ),)]),
        //end input group
        //end form

        SizedBox(height: 30),
        SwitchBox(),
        SizedBox(height: 30),
        SwitchBox(disabled: true,),
        SizedBox(height: 30),
        SwitchBox(checked: true,),
        SizedBox(height: 30),
        SwitchBox(checked: true,disabled: true,),




        SizedBox(height:40),
      ],
    );
  }
}
