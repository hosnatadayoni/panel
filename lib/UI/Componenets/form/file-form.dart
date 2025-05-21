import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/form/input-form.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
class FileForm extends StatefulWidget {
  bool? disabled;
  String? fileTxt;
  Color? fileTxtColor;
  Color? fileTxtBoxColor;
  Color? borderColor;
  bool? isMultipleFiles;
  InputSize? size;
    FileForm({
      this.disabled = false,
      this.fileTxt = 'Choose File',
      this.fileTxtColor = darkBackground,
      this.fileTxtBoxColor = color38,
      this.borderColor = color5,
      this.isMultipleFiles = false,
      this.size = InputSize.medium,
});

  @override
  State<FileForm> createState() => _FileFormState();
}

class _FileFormState extends State<FileForm> {
  PlatformFile? _pickedFile;
  List<PlatformFile>? _pickedFiles;



  String getDisplayText() {
    if (widget.isMultipleFiles!) {
      return _pickedFiles?.isNotEmpty == true
          ? _pickedFiles!.map((file) => file.name).join(', ')
          : 'فایلی انتخاب نشده';

    } else {
      return _pickedFile?.name ?? 'فایلی انتخاب نشده';
    }

  }
  Future<void> _pickFile() async {
    print('widget.isMultipleFiles>>>${widget.isMultipleFiles}');

    FilePickerResult? result;
    if (widget.isMultipleFiles!) {
      result = await FilePicker.platform.pickFiles(allowMultiple: true);
    } else {
      result = await FilePicker.platform.pickFiles();
    }
    print('result!.files>>>${result!.files}');


    if (result != null) {
      setState(() {
        if (widget.isMultipleFiles!) {
          _pickedFiles = result!.files;
          _pickedFile = null;
        } else {
          _pickedFile = result!.files.first;
          _pickedFiles = null;
        }
      });
    }
    for(var file in _pickedFiles!){
      print('mmmmmmmm>>>>${file.name}');
    }
    print('_pickedFiles>>>${_pickedFiles}');
  }
  @override
  Widget build(BuildContext context) {
    final padding = switch(widget.size!) {
    InputSize.large => EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    InputSize.medium => EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    InputSize.small => EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    };

    double textStyle = switch(widget.size!) {
    InputSize.large => 20,
    InputSize.medium => 16,
    InputSize.small => 14,
    };
    return InkWell(
      onTap: widget.disabled! ? null : _pickFile,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(width: 1, color: widget.borderColor!),
        ),
        child: Row(
          children: [
            Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight:Radius.circular(5) , bottomRight: Radius.circular(5)),
                border: Border.all(width: 1, color: widget.borderColor!),
                color: widget.fileTxtBoxColor,
              ),
              child: Txt(widget.fileTxt! , fontSize:textStyle, fontWeight: FontWeight.w400, color: widget.fileTxtColor,),
            ),
            Expanded(
              child: Container(
                padding: padding,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(5) , bottomLeft: Radius.circular(5)),
                  color:widget.disabled! ? color27: Colors.transparent,
                ),
                child: Txt(getDisplayText() , fontSize: textStyle, fontWeight: FontWeight.w400, color: widget.fileTxtColor,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
