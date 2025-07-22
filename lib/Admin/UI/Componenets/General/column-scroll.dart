import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ColumnScroll extends StatefulWidget {
  List<Widget>? children;
  Widget? emptyList;
  double padding;
  Function? getLoadedWidgets;
  Function? onEndScroll;
  Function? checkEmptyList;
  String? loadingTag;
  ColumnScroll({Key? key,this.getLoadedWidgets,this.children,this.padding=paddingSize,this.onEndScroll,this.loadingTag,this.emptyList,this.checkEmptyList}) : super(key: key);

  @override
  State<ColumnScroll> createState() => _ColumnScrollState();
}

class _ColumnScrollState extends State<ColumnScroll> {
  final _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() async{
      if(_scrollController.position.pixels > _scrollController.position.maxScrollExtent-100
          && widget.onEndScroll!=null && !AppController.loadingList.contains(widget.loadingTag)){
        await widget.onEndScroll!();
      }


    });
  }

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Obx(
            () {
          late bool isLoading;
          // if(widget.loadingTag==null)
          //  isLoading=AppController.isLoading.value;
          // else
          isLoading=AppController.loadingList.contains(widget.loadingTag);
          return !isLoading && widget.checkEmptyList!=null && widget.checkEmptyList!()?
          widget.emptyList??Container():Scrollbar(
              interactive: true,
              thickness: 10,
              thumbVisibility: size.width<500?false:true,
              trackVisibility: size.width<500?false:true,
              controller: _scrollController,

              child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                      scrollbars: false
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                        margin: EdgeInsets.only(
                            left: widget.padding, right: widget.padding),
                        width: size.width,
                        child:
                        Column(
                          children: [
                            widget.getLoadedWidgets!=null?widget.getLoadedWidgets!():Column(
                              children: widget.children??[],
                            ),
                            isLoading?
                            Container(
                              height: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: colorBtn,
                                    strokeWidth: 4,
                                  ),
                                ],
                              ),
                            ):Container(height: 100,)
                          ],
                        )
                    ),
                  )));
        }
    )
    ;
  }
}
