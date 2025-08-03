
import 'package:finance/Admin/Public/config.dart';
import 'package:flutter/material.dart';
import '../../Logic/Controllers/main-controller.dart';
import '../../Public/styles.dart';
import '../Componenets/General/img.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1),(){
      MainController.getInitData();
    });
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: background,
        body: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Img(appLogo,width: 150)
                ],
              ),
            ),
            // Img(a,color: complementaryColorShade500,width: size.width,height: 230)
          ],
        ),
      ),
    );
  }
}




