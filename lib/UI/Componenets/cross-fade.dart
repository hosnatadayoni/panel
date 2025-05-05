import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class MultiImageSliderDemo extends StatefulWidget {
  const MultiImageSliderDemo({Key? key}) : super(key: key);

  @override
  State<MultiImageSliderDemo> createState() => _MultiImageSliderDemoState();
}

class _MultiImageSliderDemoState extends State<MultiImageSliderDemo> {
  int _currentIndex = 0;
  double _duration = 1.0; // مدت زمان انیمیشن (ثانیه)

  // لیست URL تصاویر
  final List<String> _imageUrls = [
    'https://picsum.photos/250/230?random=1',
    'https://picsum.photos/230/250?random=2',
    'https://picsum.photos/250/250?random=3',
    'https://picsum.photos/230/230?random=4',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // نمایش تصویر فعلی با انیمیشن CrossFade
        AnimatedSwitcher(
          duration: Duration(milliseconds: (_duration * 1000).toInt()),
          child: Image.network(
            _imageUrls[_currentIndex],
            key: ValueKey<String>(_imageUrls[_currentIndex]), // برای تشخیص تغییر تصویر
            width: 250,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 20),
        // دکمه‌های قبلی و بعدی
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _currentIndex > 0
                  ? () {
                setState(() {
                  _currentIndex--;
                });
              }
                  : null,
              child: const Text('Previous'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: _currentIndex < _imageUrls.length - 1
                  ? () {
                setState(() {
                  _currentIndex++;
                });
              }
                  : null,
              child: const Text('Next'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // اسلایدر برای تنظیم مدت زمان انیمیشن
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Text('Animation Duration (seconds):'),
              Slider(
                value: _duration,
                min: 0.1,
                max: 3.0,
                divisions: 29,
                label: _duration.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _duration = value;
                  });
                },
              ),
            ],
          ),
        ),
        // نمایش شماره تصویر فعلی
        Text(
          'Image ${_currentIndex + 1} of ${_imageUrls.length}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

