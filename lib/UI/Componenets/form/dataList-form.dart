import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class DataListInput extends StatelessWidget {
   List<String> options;
   String label;
   String hintText;
   TextEditingController _controller = TextEditingController();
   bool? disabled;
   Color? lableColor;
   Color? disableColor;

  DataListInput({
    required this.options,
    required this.label,
    this.hintText = 'Type to search...',
    this.disabled = false,
    this.lableColor = darkBackground,
    this.disableColor = color38,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Txt(label, color: this.lableColor,),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: this.disabled! ? this.disableColor : Colors.white,
            borderRadius: BorderRadius.circular(4)
          ),
          
          child: TypeAheadField<String>(
            suggestionsCallback: (pattern) => options.where((item) =>
                item.toLowerCase().contains(pattern.toLowerCase())),
            itemBuilder: (context, item) => ListTile(
              title: Txt(item),
            ),
            onSuggestionSelected: (suggestion) {
              if (!this.disabled!) {
                _controller.text = suggestion;
                debugPrint('Selected $suggestion');
              }
            },
            textFieldConfiguration: TextFieldConfiguration(
              enabled: !this.disabled!,
              controller: _controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            noItemsFoundBuilder: (context) =>  Container(
              padding: EdgeInsets.all(12),
              child: Txt('No items found'),
            ),
          ),
        ),
      ],
    );
  }
}