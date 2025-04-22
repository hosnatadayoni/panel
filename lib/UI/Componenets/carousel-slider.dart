import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/img.dart';
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

class MyCarousel extends StatefulWidget {
   List<String>? imageUrls;
   bool isAutoPlay;
   bool showIndicators;
   Alignment indicatorAlignment;
   bool isCaption;
   List<Caption>? captions;


   MyCarousel({
    this.imageUrls,
    this.isAutoPlay = false,
    this.showIndicators = false,
    this.indicatorAlignment = Alignment.bottomCenter,
    this.isCaption = false,
    this.captions,
  });

  @override
  _MyCarouselState createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel> {
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          items: widget.imageUrls!.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 400,
            aspectRatio: 16/9,
            viewportFraction: 1.0,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: widget.isAutoPlay,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              debugPrint('Index: $index, Reason: $reason');
              setState(() {
                print('index>>>${index}');
                _currentIndex = index;
              });
            },
          ),
        ),

        Positioned(
          right: 10,
          child: IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
              padding: EdgeInsets.all(12),
            ),
            onPressed: () {
              _carouselController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
          ),
        ),
        Positioned(
          left: 10,
          child: IconButton(
            icon: Icon(Icons.chevron_right, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
              padding: EdgeInsets.all(12),
            ),
            onPressed: () {
              _carouselController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
          ),
        ),

            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isCaption && widget.captions != null && widget.captions!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          // Header
                          if (widget.captions![_currentIndex].header != null)
                            Text(
                            widget.captions![_currentIndex].header!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              shadows: [
                              Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                              ),
                              ],
                            ),
                          ),
                          if (widget.captions![_currentIndex].header != null) SizedBox(height: 15),
                          // Body
                          if (widget.captions![_currentIndex].body != null)
                             Text(
                            widget.captions![_currentIndex].body!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black,
                                  offset: Offset(2.0, 2.0),
                                ),
                                  ],
                            ),
                                ),
                        ],
                      ),
                    ),
                  if (widget.showIndicators)
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.imageUrls!.asMap().entries.map((entry) {
                      return InkWell(
                        onTap: () => {
                          _carouselController.animateToPage(entry.key),
                        },
                        child: Container(
                          width: 30,
                          height: 3,
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              color: color24
                          ),
                          child: _currentIndex == entry.key
                              ? Center(
                            child: Container(
                              width: 30,
                              height: 3,
                              decoration: BoxDecoration(
                                color: whiteColor,
                              ),
                            ),
                          )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )
            ),
      ],
    );
  }
}

class Caption {
  String? header;
   String? body;

  Caption({this.header, this.body});
}


