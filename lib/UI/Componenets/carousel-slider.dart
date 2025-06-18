import 'dart:async';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/img.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
// class DetailSlider extends StatefulWidget {
//   List images=[];
//   double padding;
//   double? height;
//   bool? isMainPage;
//
//
//   DetailSlider(this.images,{Key? key,this.padding=0,this.height,this.isMainPage=false}) : super(key: key);
//
//   @override
//   _DetailSliderState createState() => _DetailSliderState();
// }
//
// class _DetailSliderState extends State<DetailSlider> {
//   int _current=0;
//   bool like = true;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var size=MediaQuery.of(context).size;
//     return Container(
//       width: maxItemWidth,
//       // height: widget.height??size.height/5,
//       padding: EdgeInsets.all(paddingSize),
//       // margin: EdgeInsets.only(top: 20,bottom: paddingSize),
//       decoration: BoxDecoration(
//         color: whiteColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           CarouselSlider(
//               options: CarouselOptions(
//                 // height:widget.height ==null? size.width<maxItemWidth?size.height/5:maxItemWidth:widget.height,
//                   initialPage: 0,
//                   enlargeCenterPage: false,
//                   disableCenter: false,
//                   enlargeStrategy: CenterPageEnlargeStrategy.scale,
//                   // reverse: true,
//                   // autoPlay: true,
//                   scrollDirection: Axis.horizontal,
//                   viewportFraction: 1,
//                   enableInfiniteScroll: false,
//                   onPageChanged:(index,a){
//                     setState(() {
//                       _current=index;
//                     });
//                   }
//               ),
//               items: [
//                 for (int i = 0; i < widget.images.length; i++)
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: widget.padding),
//                     child:  Img(
//                       widget.images[i],
//                       width: maxItemWidth,
//                       height: widget.height ==null? size.width<maxItemWidth?165:maxItemWidth:widget.height,isNetwork: true,radius: 25,),
//
//                   ),
//
//               ]),
//           SizedBox(height: 15,),
//           widget.images.length>1?Positioned(
//               bottom: 25,
//               child:Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     for (int i = 0; i < widget.images.length; i++)
//                       Container(
//                           width: 30,
//                           height: 3,
//                           margin: EdgeInsets.symmetric(vertical:0, horizontal: 3.0),
//                           decoration: BoxDecoration(
//                             color: _current == i
//                                 ? color24
//                                 : Colors.red,
//                           )
//                       )]
//
//               )):Container(),
//         ],
//       ),
//     );
//   }
// }

// class MyCarousel extends StatefulWidget {
//    List<dynamic>? imageUrls;
//    bool isAutoPlay;
//    bool showIndicators;
//    Alignment indicatorAlignment;
//    bool hasCaption;
//    List<Caption>? captions;
//    bool hasfadeEffect;
//
//
//    MyCarousel({
//     this.imageUrls,
//     this.isAutoPlay = false,
//     this.showIndicators = false,
//     this.indicatorAlignment = Alignment.bottomCenter,
//     this.hasCaption = false,
//     this.captions,
//      this.hasfadeEffect = false,
//   });
//
//   @override
//   _MyCarouselState createState() => _MyCarouselState();
// }
//
// class _MyCarouselState extends State<MyCarousel> {
//   final CarouselController _carouselController = CarouselController();
//   int _currentIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         CarouselSlider(
//           carouselController: _carouselController,
//           items: widget.imageUrls!.map((url) {
//             return Builder(
//               builder: (BuildContext context) {
//                 return Container(
//                   width: MediaQuery.of(context).size.width,
//                   margin: EdgeInsets.symmetric(horizontal: 5.0),
//                   decoration: BoxDecoration(
//                     color: Colors.grey,
//                   ),
//                   child: Image.network(
//                     url,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(
//                           value: loadingProgress.expectedTotalBytes != null
//                               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//                               : null,
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
//                   ),
//                 );
//               },
//             );
//           }).toList(),
//           options: CarouselOptions(
//             height: 400,
//             aspectRatio: 16/9,
//             viewportFraction: 1.0,
//             initialPage: 0,
//             enableInfiniteScroll: true,
//             reverse: false,
//             autoPlay: widget.isAutoPlay,
//             enlargeCenterPage: false,
//             scrollDirection: Axis.horizontal,
//             // scrollPhysics: widget.hasfadeEffect ? NeverScrollableScrollPhysics() :PageScrollPhysics(),
//             // pageSnapping: widget.hasfadeEffect ? false: true,
//             onPageChanged: (index, reason) {
//               debugPrint('Index: $index, Reason: $reason');
//               setState(() {
//                 print('index>>>${index}');
//                 _currentIndex = index;
//               });
//             },
//           ),
//         ),
//
//         Positioned(
//           right: 10,
//           child: IconButton(
//             icon: Icon(Icons.chevron_left, color: Colors.white),
//             style: IconButton.styleFrom(
//               backgroundColor: Colors.black54,
//               padding: EdgeInsets.all(12),
//             ),
//             onPressed: () {
//               _carouselController.nextPage(
//                   duration: Duration(milliseconds: 300),
//                   curve: Curves.easeInOut);
//             },
//           ),
//         ),
//         Positioned(
//           left: 10,
//           child: IconButton(
//             icon: Icon(Icons.chevron_right, color: Colors.white),
//             style: IconButton.styleFrom(
//               backgroundColor: Colors.black54,
//               padding: EdgeInsets.all(12),
//             ),
//             onPressed: () {
//               _carouselController.previousPage(
//                   duration: Duration(milliseconds: 300),
//                   curve: Curves.easeInOut);
//             },
//           ),
//         ),
//
//             Positioned(
//               bottom: 20,
//               left: 0,
//               right: 0,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (widget.hasCaption && widget.captions != null && widget.captions!.isNotEmpty)
//                     Container(
//                       padding: const EdgeInsets.only(bottom: 20),
//                       child: Column(
//                         children: [
//                           // Header
//                           if (widget.captions![_currentIndex].header != null)
//                             Txt(
//                             widget.captions![_currentIndex].header!,
//                             color: whiteColor,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           if (widget.captions![_currentIndex].header != null) SizedBox(height: 15),
//                           // Body
//                           if (widget.captions![_currentIndex].body != null)
//                              Txt(
//                             widget.captions![_currentIndex].body!,
//                             color: whiteColor,
//                             fontSize: 14,
//                            ),
//                         ],
//                       ),
//                     ),
//                   if (widget.showIndicators)
//                     Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: widget.imageUrls!.asMap().entries.map((entry) {
//                       return InkWell(
//                         onTap: () => {
//                           _carouselController.animateToPage(entry.key),
//                         },
//                         child: Container(
//                           width: 30,
//                           height: 3,
//                           margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//                           decoration: BoxDecoration(
//                               color: color24
//                           ),
//                           child: _currentIndex == entry.key
//                               ? Center(
//                             child: Container(
//                               width: 30,
//                               height: 3,
//                               decoration: BoxDecoration(
//                                 color: whiteColor,
//                               ),
//                             ),
//                           )
//                               : null,
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               )
//             ),
//       ],
//     );
//   }
// }
//
// class Caption {
//   String? header;
//    String? body;
//
//   Caption({this.header, this.body});
// }


class MyCarousel extends StatefulWidget {
   List<CarouselItem>? items;
   bool isAutoPlay;
   bool showIndicators;
   Alignment indicatorAlignment;
   bool hasCaption;
   bool ride;
   bool hasControl;
   bool hasTouchSwipping;
   // bool isDark;
   Color colorBox;
   Color colorIcon;
   Color colorIndicator;
   Color colorIndicatorActive;
   Color colorTxt;
   bool isCrossFade;

   MyCarousel({
    Key? key,
    this.items,
    this.isAutoPlay = false,
    this.showIndicators = false,
    this.indicatorAlignment = Alignment.bottomCenter,
    this.hasCaption = false,
    this.ride = false,
     this.hasControl = false,
     this.hasTouchSwipping = false,
     // this.isDark = false,
     this.colorBox = color26,
     this.colorIcon  = whiteColor,
     this.colorIndicator = color27,
     this.colorIndicatorActive = whiteColor,
     this.colorTxt = whiteColor,
     this.isCrossFade = false,


  }) : super(key: key);

  @override
  _MyCarouselState createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel>  with WidgetsBindingObserver {
  final CarouselController _carouselController = CarouselController();
  Duration _currentInterval = Duration(seconds: 5);
  Duration _transitionDuration = Duration(milliseconds: 500);
  int _currentIndex=0;
  bool _isAutoPlayPaused = false;
  bool pauseOnHover = true;
  bool pauseOnVisibilityChange = true;
  bool _isPageVisible = true;
  double _duration = 1;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.items!.indexWhere((item) => item.isActive!);
    if (_currentIndex == -1) _currentIndex = 0;
    WidgetsBinding.instance.addObserver(this);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _stopAutoPlay();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!pauseOnVisibilityChange) return;

    setState(() {
      _isPageVisible = state == AppLifecycleState.resumed;
    });

    if (widget.isCrossFade) {
      if (_isPageVisible && widget.isAutoPlay) {
        _startAutoPlay();
      } else {
        _stopAutoPlay();
      }
    }
  }

  bool _hasUserInteracted = false;
  bool get _shouldAutoPlay {
    return widget.isAutoPlay &&
        !_isAutoPlayPaused &&
        _isPageVisible &&
        (!widget.ride || _hasUserInteracted);
  }
  void _handleUserInteraction() {
    if (!_hasUserInteracted) {
     setState(() {
       _hasUserInteracted = true;
       if(widget.ride){
         widget.isAutoPlay = true;
       }

     });
    }
  }

  // void _startAutoPlay() {
  //   // if (!widget.isAutoPlay || !widget.isCrossFade) return;
  //
  //   // _stopAutoPlay();
  //   _currentInterval = widget.items?[_currentIndex].autoPlayInterval ?? Duration(milliseconds: 5);
  //   _autoPlayTimer = Timer.periodic(_currentInterval, (timer) {
  //     if (_shouldAutoPlay) {
  //       setState(() {
  //         _currentIndex = (_currentIndex + 1) % widget.items!.length;
  //         // _currentInterval = widget.items?[_currentIndex].autoPlayInterval ?? Duration(seconds: 5);
  //       });
  //     }
  //   });
  // }
  // void _startAutoPlay() {
  //   _stopAutoPlay();
  //   if (!widget.isAutoPlay) return;
  //
  //
  //   _currentInterval = widget.items?[_currentIndex].autoPlayInterval ?? Duration(seconds: 5);
  //
  //   _autoPlayTimer = Timer.periodic(_currentInterval, (timer) {
  //     if (_shouldAutoPlay) {
  //       if(!widget.isCrossFade){
  //         _carouselController.nextPage(
  //           duration: _transitionDuration,
  //           curve: Curves.easeInOut,
  //         );
  //       }
  //     }
  //   });
  // }
  void _startAutoPlay() {
    _stopAutoPlay();
    if (!widget.isAutoPlay || !mounted) return;

    _currentInterval = widget.items?[_currentIndex].autoPlayInterval ?? Duration(seconds: 5);

    _autoPlayTimer = Timer.periodic(_currentInterval, (timer) {
      if (_shouldAutoPlay && mounted) {
        if (widget.isCrossFade) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % widget.items!.length;
          });
        } else {
          _carouselController.nextPage(
            duration: _transitionDuration,
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }
  void _onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
    if (widget.isAutoPlay) {
      _startAutoPlay();
    }
  }
  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MouseRegion(
      onEnter: pauseOnHover ? (_) => setState(() => _isAutoPlayPaused = true) : null,
      onExit:  pauseOnHover ? (_) => setState(() => _isAutoPlayPaused = false) : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.isCrossFade?AnimatedSwitcher(
            // duration: Duration(milliseconds: (_duration * 1000).toInt()),
            duration:_currentInterval ,
            child: Container(
              key: ValueKey<String>(widget.items![_currentIndex].imageUrl),
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                color: widget.colorBox,
              ),
              child: Img(
                width: size.width,
                widget.items![_currentIndex].imageUrl,
              ),
            ),
          ):
          IgnorePointer(
            ignoring:widget.hasTouchSwipping == false ?  true : false,
            child: CarouselSlider(
              carouselController: _carouselController,
              items: widget.items!.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        // color: widget.isDark ? color25 :color26,
                        color: widget.colorBox
                      ),
                      child: Img(
                        width: size.width,
                        item.imageUrl,
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 400,
                aspectRatio: 16/9,
                viewportFraction: 1.0,
                initialPage: _currentIndex,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: _shouldAutoPlay,
                pauseAutoPlayOnTouch: true,
                autoPlayInterval: _currentInterval,
                autoPlayAnimationDuration: _transitionDuration,
                onPageChanged: _onPageChanged,
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: false,
                scrollDirection: Axis.horizontal,
                // onPageChanged: (index, reason) {
                //   setState(() {
                //     // print('current index>>>${index}');
                //     _currentIndex = index;
                //     _currentInterval = widget.items?[index].autoPlayInterval ?? Duration(seconds: 5);
                //     // print('_currentInterval>>>${_currentInterval}');
                //   });
                // },
              ),
            ),
          ),
         if(widget.hasControl == false)
          Positioned(
            right: 10,
            child: IconButton(
              // icon: Icon(Icons.chevron_left, color:widget.isDark ? color26 : whiteColor),
              icon: Icon(Icons.chevron_left, color:widget.colorIcon),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                padding: EdgeInsets.all(12),
              ),
              onPressed: () {
                _handleUserInteraction();
                if (widget.isCrossFade) {
                  setState(() {
                    _currentIndex = (_currentIndex + 1) % widget.items!.length;
                  });
                }
                else{
                  _carouselController.nextPage(
                    // duration: Duration(milliseconds: 300),
                    // duration: _currentInterval,
                    duration: _transitionDuration,
                    curve: Curves.easeInOut,
                  );
                }

              },
            ),
          ),
         if(widget.hasControl == false)
          Positioned(
            left: 10,
            child: IconButton(
              // icon: Icon(Icons.chevron_right, color:widget.isDark ? color26 : whiteColor),
              icon: Icon(Icons.chevron_right, color:widget.colorIcon),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                padding: EdgeInsets.all(12),
              ),
              onPressed: () {
                _handleUserInteraction();
                if (widget.isCrossFade) {
                  setState(() {
                    _currentIndex = (_currentIndex - 1) % widget.items!.length;
                  });
                }
                else{
                  _carouselController.previousPage(
                    // duration: Duration(milliseconds: 300),
                    // duration: _currentInterval,
                    duration: _transitionDuration,
                    curve: Curves.easeInOut,
                  );
                }

              },
            ),
          ),
        if(widget.hasControl == false)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.hasCaption)
                  if(widget.items![_currentIndex].caption != null)
                     Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        if (widget.items![_currentIndex].caption!.header != null)
                          Txt(
                            widget.items![_currentIndex].caption!.header!,
                            // color:widget.isDark ? blackColor : whiteColor,
                            color:widget.colorTxt,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        if (widget.items![_currentIndex].caption!.header != null)
                          SizedBox(height: 15),
                        if (widget.items![_currentIndex].caption!.body != null)
                          Txt(
                            widget.items![_currentIndex].caption!.body!,
                            // color:widget.isDark ? blackColor : whiteColor,
                            color:widget.colorTxt,
                            fontSize: 14,
                          ),
                      ],
                    ),
                  ),
                if (widget.showIndicators)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.items!.asMap().entries.map((entry) {
                      return InkWell(
                        // onTap: () => _carouselController.animateToPage(entry.key),
                        onTap: (){
                          _handleUserInteraction();
                          if (widget.isCrossFade) {
                            setState(() {
                              _currentIndex = entry.key % widget.items!.length;
                            });
                          }
                          else{
                            _carouselController.animateToPage(entry.key);
                          }

                        },
                        child: Container(
                          width: 30,
                          height: 3,
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            // color: widget.isDark ? color26 :color27,
                            color: widget.colorIndicator,
                          ),
                          child: _currentIndex == entry.key
                              ? Center(
                            child: Container(
                              width: 30,
                              height: 3,
                              decoration: BoxDecoration(
                                // color:widget.isDark ? blackColor: whiteColor,
                                color: widget.colorIndicatorActive,
                              ),
                            ),
                          )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Caption {
  final String? header;
  final String? body;

  Caption({this.header, this.body});
}

class CarouselItem {
   String imageUrl;
   Duration? autoPlayInterval;
   Caption? caption;
   bool? isActive;

  CarouselItem({
    required this.imageUrl,
    this.autoPlayInterval,
    this.caption,
    this.isActive = false,
  });
}

