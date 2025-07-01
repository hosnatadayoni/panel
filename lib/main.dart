import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Models/dataModel.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Views/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'Admin/Logic/Controllers/main-controller.dart';
import 'Admin/Logic/Controllers/app_localization_delegate.dart';
import 'Admin/UI/Views/table-page.dart';

void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(DataModelAdapter());

  await MainController.loadJson();
  await MainController.loadData();
  // var a= await DB('itemsOrder2').parent(parentTable: 'order3',parentId:'77756a94-a90f-4806-abc3-7b1ea690bf17' ).where('_id','\$eq','e71c7ae3-0b0a-43ec-8260-b5d38d89a469').updateRecord(
  //     {'title':'maryam'});
  // print('main>>>${a}');
  // var box=await Hive.openBox<DataModel>('itemsOrder2');
  // var box2=await Hive.openBox<DataModel>('order3');
  // box.clear();
  // box2.clear();
  // await Token.setToken('3ba7fd50-69c5-4293-8aa8-77e752a967ae');
  // ConncetServerController.createProject();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: itemColor8,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'IRANSanse',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        hoverColor: Colors.transparent,
        primarySwatch:primarySwatch,
      ),
      textDirection: TextDirection.rtl,
      builder: (context, child) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, child!),
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(450, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
      ),
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale.fromSubtags(languageCode: 'fa'),
        const Locale.fromSubtags(languageCode: 'ar'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocaleLanguage in supportedLocales) {
          if (supportedLocaleLanguage.languageCode == locale!.languageCode &&
              supportedLocaleLanguage.countryCode == locale.countryCode) {
            return supportedLocaleLanguage;
          }
        }
        return supportedLocales.first;
      },
      initialRoute: '/',
      routes: {
        '/':(context)=>DashboardPage(),
        '/TablePage': (context) =>  TablePage(),
      },
    );
  }
}
