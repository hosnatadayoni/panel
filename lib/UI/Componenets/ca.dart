import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CrossfadeCarousel extends StatefulWidget {
  final List<dynamic> imageUrls; // تغییر به dynamic برای پشتیبانی از String و Widget

  const CrossfadeCarousel({Key? key, required this.imageUrls}) : super(key: key);

  @override
  _CrossfadeCarouselState createState() => _CrossfadeCarouselState();
}

class _CrossfadeCarouselState extends State<CrossfadeCarousel> {
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Crossfade Image/Widget Container
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: _buildCurrentItem(), // تابعی که آیتم فعلی را می‌سازد
        ),

        // Carousel Slider (برای کنترل پیمایش)
        CarouselSlider(
          items: widget.imageUrls.map((item) => Container()).toList(),
          options: CarouselOptions(
            height: 0,
            viewportFraction: 1.0,
            initialPage: _currentIndex,
            enableInfiniteScroll: true,
            // autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          carouselController: _carouselController,
        ),

        // دکمه‌های ناوبری
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () => _carouselController.nextPage(),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () => _carouselController.previousPage(),
            ),
          ],
        ),
      ],
    );
  }

  // تابعی که بررسی می‌کند آیتم String است یا Widget
  Widget _buildCurrentItem() {
    final currentItem = widget.imageUrls[_currentIndex];

    if (currentItem is String) {
      // اگر String بود، تصویر شبکه را نمایش بده
      return Container(
        key: ValueKey<String>(currentItem),
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(currentItem),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (currentItem is Widget) {
      // اگر Widget بود، مستقیماً آن را نمایش بده
      return Container(
        key: ValueKey<Widget>(currentItem),
        width: double.infinity,
        height: 300,
        child: currentItem,
      );
    } else {
      // اگر نوع نامعتبر بود، یک placeholder نمایش بده
      return Container(
        key: ValueKey<String>("invalid_item_$_currentIndex"),
        width: double.infinity,
        height: 300,
        color: Colors.grey,
        child: Center(child: Text("Invalid Item")),
      );
    }
  }
}