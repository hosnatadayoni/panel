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

const Color dark = CupertinoColors.darkBackgroundGray;
const Color primaryDark = Color(0xff192430);
const Color background = Color(0xff202e3d);
const Color primary = Color(0xff4053BA);
const Color color1 = Color(0xff474747);
const Color colorBtn = Color(0xff0d6efd);
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


