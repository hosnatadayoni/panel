import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'config.dart';

const double maxItemWidth=900;
const double paddingSize=15;
const double borderSize=1;


final List<BoxShadow> shadow=[BoxShadow(color: Colors.black.withOpacity(0.02),spreadRadius: 0,blurRadius: 10,offset: Offset(0,2))];
const Color blackColor=Color(0xff000000);
const Color whiteColor=Color(0xffFFFFFF);
const Color redColor = Color(0xffF30000);
const Color errorColor=Color(0xffD32F2F);
const Color successColor=Color(0xff4CAF50);
const Color infoColor=Color(0xff0cccd2);
const Color warningColor=Color(0xffFFB300);

const Color primaryDark = Color(0xff192430);
const Color background = Color(0xff202e3d);
const Color primary = Color(0xff4053BA);
const Color color1 = Color(0xff474747);
const Color colorBtn = Color(0xff0d6efd);
const Color colorHoverBtn = Color(0xff0b5ed7);
const Color darkBackground = Color(0xff212529);
const Color dark2 = Color(0xff474747);
const Color backgroundLight = Color(0xffF7F7FC);
const Color itemColor8 = Color(0xffFF7D42);
const Color colorDropDown = Color(0xffF8F8F8);
const Color primary2 = Color(0xff5a8dee);
const Color color2 = Color(0xff4c4747);
const Color color3 = Color(0xff858d96);
const Color color5 = Color(0xffdee2e6);
const Color color6 = Color(0xffF8F8F8);
const Color color7 = Color(0xfff3f5f6);
const Color itemColor13 = Color(0xffFF9A62);
const Color itemColor25 = Color(0xffE9E9E9);
const Color itemColor3 = Color(0xffB5B5B6);
const Color itemColor5 = Color(0xff9B9B9B);
const Color itemColor1= Color(0xff404040);
const Color itemColor4 = Color(0xff2F2D2C);
const Color itemColor11 = Color(0xff424242);
const Color itemColor39 = Color(0xffD5D5D5);
const Color itemColor34 = Color(0xffEFEFEF);
const Color itemColor7 = Color(0xffFFB696);
const Color itemColor2 = Color(0xffF56A4D);
const Color color8 = Color(0xff424e8f);
const Color color9 = Color(0xff131c26);
const Color color11 = Color(0xffFF982E);
const Color color12 = Color(0xffe5e7f2);
const Color color13 = Color(0xff6c757d);
const Color color14 = Color(0xffA3A3A3);
const Color color15 = Color(0xfffF3F2F7);
const Color color16 = Color(0xffffbb54);
const Color color17 = Color(0xff00a389);
const Color color18 = Color(0xff6beec2);
const Color color19 = Color(0xfffebc3b);
const Color color20 = Color(0xff464255);
const Color color21 = Color(0xff00A389);
const Color color22 = Color(0xfff1e6b9);
const Color color23 = Color(0xffef9a91);
const Color color24 = Color(0xffbbbbbb);
const Color color25 = Color(0xfff5f5f5);
const Color color26 = Color(0xff7a7a7a);
const Color color27 = Color(0xffbbbbbb);
const Color color28 = Color(0xffd2d2d2);
const Color color29 =  Color.fromRGBO(248, 248, 248, 1.0);
const Color color30 = Color(0xff7f7f7f);
const Color color31 = Color(0xff909294);
const Color color32 = Color(0xffc7c8c9);
const Color color33 = Color(0xff5c636a);
const Color color34 = Color(0xff343a40);
const Color color35 = Color(0xff7e7e7e);
const Color color36 = Color(0xff3f3f3f);
const Color color37 = Color(0xff61a0fd);
const Color color38 = Color(0xffe9ecef);
const Color color39 = Color(0xfff8f9fa);
const Color color40 = Color(0xffbfbfbf);
const Color linkColor = Color(0xff247cfd);
const Color linkHoverColor = Color.fromRGBO(10, 88, 202, 1.0);
const Color lightPurple = Color(0xffeae0ef);
const Color purpleColor = Color(0xffAB54DB);
const Color lightBlueColor = Color(0xff00AAFF);
const Color lightBlackColor = Color(0xff17161E);
const secondry = Color(0xff6c757d);
const success = Color(0xff198754);
const danger = Color(0xffdc3545);
const warning = Color(0xffffc107);
const info = Color(0xff0dcaf0);
const light = Color(0xfff8f9fa);
const dark = Color(0xff212529);

//hover
const Color primaryHover = Color(0xff0b5ed7);
const secondryHover = Color(0xff5c636a);
const successHover = Color(0xff157347);
const dangerHover = Color(0xffbb2d3b);
const warningHover = Color(0xffffca2c);
const infoHover = Color(0xff31d2f2);
const lightHover = Color(0xffd3d4d5);
const darkHover = Color(0xff424649);

//color box
const alertPrimary = Color(0xffcfe2ff);
const alertSecondry = Color(0xffe2e3e5);
const alertSuccess = Color(0xffd1e7dd);
const alertDanger = Color(0xfff8d7da);
const alertWarning = Color(0xfffff3cd);
const alertInfo = Color(0xffcff4fc);
const alertLight = Color(0xfffcfcfd);
const alertDark = Color(0xffced4da);

//color content
const alertContentPrimary = Color(0xff052c65);
const alertContentSecondry = Color(0xff2b2f32);
const alertContentSuccess = Color(0xff0a3622);
const alertContentDanger = Color(0xff58151c);
const alertContentWarning = Color(0xff664d03);
const alertContentInfo = Color(0xff055160);
const alertContentLight = Color(0xff495057);
const alertContentDark = Color(0xff495057);




final LinearGradient gradiant1 =  LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    itemColor7,
    itemColor8,
  ],
);




Map<int, Color> _primaryMap = {
  50: appColor.withOpacity(0.05),
  100: appColor.withOpacity(0.1),
  200: appColor.withOpacity(0.2),
  300: appColor.withOpacity(0.3),
  400: appColor.withOpacity(0.4),
  500: appColor.withOpacity(0.5),
  600: appColor.withOpacity(0.6),
  700: appColor.withOpacity(0.7),
  800: appColor.withOpacity(0.8),
  900: appColor.withOpacity(0.9),
};

MaterialColor primarySwatch = MaterialColor(Colors.blue[600]!.value, _primaryMap);


