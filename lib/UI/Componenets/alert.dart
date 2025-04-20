import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// void showCustomAnimatedAlert(
//     BuildContext context,
//     String title,
//     Color colorTitle,
//     Color color,
//     Color colorBox, {
//       IconData? icon,
//       Color? iconColor,
//       String? linkText,
//       VoidCallback? onLinkTap,
//     }) {
//   showDialog(
//     context: context,
//     builder: (context) => Dialog(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 if (icon != null) Icon(icon, color: iconColor),
//                 if (icon != null) SizedBox(width: 5),
//                 Expanded(
//                   child: RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: title.replaceAll(linkText ?? '', ''),
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: colorTitle,
//                           ),
//                         ),
//                         if (linkText != null && linkText.isNotEmpty)
//                           TextSpan(
//                             text: linkText,
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: colorTitle,
//                               decoration: TextDecoration.underline,
//                             ),
//                             recognizer: TapGestureRecognizer()
//                               ..onTap = onLinkTap ?? () {},
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Center(
//                 child: Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: colorBox,
//                   ),
//                   child: Center(
//                     child: Txt(
//                       'تایید',
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

void showCustomAnimatedAlert(
    BuildContext context,
    String title,
    Color colorTitle,
    Color color,
    Color colorBox, {
      IconData? icon,
      Color? iconColor,
      List<TextSegment>? textSegments, // لیست بخش‌های متن با نوع (متن معمولی یا لینک)
    }) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) Icon(icon, color: iconColor),
                if (icon != null) SizedBox(width: 5),
                Expanded(
                  child: RichText(
                    text: _buildTextSpan(
                      textSegments ?? [TextSegment(text: title)],
                      colorTitle,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colorBox,
                  ),
                  child: Center(
                    child: Text(
                      'تایید',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

TextSpan _buildTextSpan(List<TextSegment> segments, Color defaultColor) {
  final textSpans = <TextSpan>[];

  for (final segment in segments) {
    if (segment.isLink) {
      textSpans.add(
        TextSpan(
          text: segment.text,
          style: TextStyle(
            color: segment.color ?? defaultColor,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          ),
          recognizer: TapGestureRecognizer()..onTap = segment.onTap,
        ),
      );
    } else {
      textSpans.add(
        TextSpan(
          text: segment.text,
          style: TextStyle(
            color: segment.color ?? defaultColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  return TextSpan(children: textSpans);
}

class TextSegment {
  final String text;
  final bool isLink;
  final Color? color;
  final VoidCallback? onTap;

  TextSegment({
    required this.text,
    this.isLink = false,
    this.color,
    this.onTap,
  });
}