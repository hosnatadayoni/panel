import 'package:finance/Public/images.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/btn-group/btn-group-item.dart';
import 'package:finance/UI/Componenets/btn-group/btn-group.dart';
import 'package:finance/UI/Componenets/carousel-slider.dart';
import 'package:finance/UI/Componenets/close-btn.dart';
import 'package:finance/UI/Componenets/collapse.dart';
import 'package:finance/UI/Componenets/dropDown/drop-down-item.dart';
import 'package:finance/UI/Componenets/dropDown/drop-down.dart';
import 'package:finance/UI/Componenets/form.dart';
import 'package:finance/UI/Componenets/modal.dart';
import 'package:finance/UI/Componenets/placeholder/btn-placeholder.dart';
import 'package:finance/UI/Componenets/popOvers.dart';
import 'package:finance/UI/Componenets/spinner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Public/styles.dart';
import 'btn.dart';
import 'placeholder/content-placeholder.dart';
import 'placeholder/img-placeholder.dart';
import 'progress/progress-item.dart';
import 'progress/progress.dart';
class TestComponent2 extends StatelessWidget {
  const TestComponent2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children:[
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
        CustomModal(header: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Launch demo modal',),
        SizedBox(height:40),
        CustomModal(header: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Launch static backdrop modal',staticBackdrop: true),
        SizedBox(height:40),
        CustomModal(header: 'ssss',body: Txt('Where can I get some There are many variations of passages of Lorem Ipsum available, but '
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
        CustomModal(header: 'ssss',body: Txt('Where can I get some There are many variations of passages of Lorem Ipsum available, but '
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
        CustomModal(header: 'ssss',body: Txt('Where can I get some There are many variations of passages of Lorem Ipsum available, but '
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
        CustomModal(header: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Small Modal',modalSize: ModalSize.small),
        SizedBox(height:40),
        CustomModal(header: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Default Modal',),
        SizedBox(height:40),
        CustomModal(header: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Large Modal',modalSize: ModalSize.large),
        SizedBox(height:40),
        CustomModal(header: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Extra Large Modal', modalSize: ModalSize.xlarge),
        SizedBox(height:40),
        CustomModal(header: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Full Screen', modalSize: ModalSize.fullScreen),
        SizedBox(height:40),
        //fullscrenn responsive
        CustomModal(header: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Full screen below sm', modalFullscreenMode: ModalFullscreenMode.smDown),
        SizedBox(height:40),
        CustomModal(header: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Full screen below md', modalFullscreenMode: ModalFullscreenMode.mdDown),
        SizedBox(height:40),
        CustomModal(header: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Full screen below lg', modalFullscreenMode: ModalFullscreenMode.lgDown),
        SizedBox(height:40),
        CustomModal(header: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Full screen below xl', modalFullscreenMode: ModalFullscreenMode.xlDown),
        SizedBox(height:40),
        CustomModal(header: 'ssss',body: Txt('aaaaaa' , fontSize: 16, fontWeight: FontWeight.w400,),titleBox: 'Save Message', btnTxt: 'Full screen below xxl', modalFullscreenMode: ModalFullscreenMode.xxlDown),
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
            ButtonItem(type: btnType.primary,contetnBtn: Txt('left', color: whiteColor, fontSize:16, fontWeight: FontWeight.w400,textAlign: TextAlign.center,),),
            ButtonItem(type: btnType.primary , contetnBtn: Txt('middel', color: whiteColor, fontSize:16, fontWeight: FontWeight.w400,textAlign: TextAlign.center,) , isChechked: true , ),
            ButtonItem(type: btnType.primary ,contentBtnDropDown: 'drop down' ,isDropdown: true , itemsDropDown: [
              DropdownItem(text: "Dropdown item text", isHeader: true ),
              DropdownItem(text: "Action", value: "action"),
              DropdownItem(text: "Another action", value: "another_action"),
              DropdownItem(text: "Something else here", value: "something_else"),
            ]  , ),
            ButtonItem(type: btnType.primary,contetnBtn: Txt('right', color: whiteColor, fontSize:16, fontWeight: FontWeight.w400,textAlign: TextAlign.center,)  , ),
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
      ]
    );
  }
}
