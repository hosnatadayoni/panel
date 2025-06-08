import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/form/input-form.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
class FileForm extends StatefulWidget {
  bool? disabled;
  String? fileTxt;
  Color? fileTxtColor;
  Color? fileTxtBoxColor;
  Color? fileTxtBoxHoverColor;
  Color? borderColor;
  bool? isMultipleFiles;
  InputSize? size;
  BorderRadius? borderRadius;
  String? lable;
  Color? lableColor;
    FileForm({
      this.disabled = false,
      this.fileTxt = 'Choose File',
      this.fileTxtColor = darkBackground,
      this.fileTxtBoxColor = color38,
      this.fileTxtBoxHoverColor = color40,
      this.borderColor = color5,
      this.isMultipleFiles = false,
      this.size = InputSize.medium,
      this.borderRadius,
      this.lable,
      this.lableColor = dark,
});

  @override
  State<FileForm> createState() => _FileFormState();
}

class _FileFormState extends State<FileForm> {
  PlatformFile? _pickedFile;
  List<PlatformFile>? _pickedFiles;
  Rx<bool> isHover = false.obs;



  String getDisplayText() {
    if (widget.isMultipleFiles!) {
      return _pickedFiles?.isNotEmpty == true
          ? _pickedFiles!.map((file) => file.name).join(', ')
          : '${AppController.of(context)!.value('No file selected')}';

    } else {
      return _pickedFile?.name ?? '${AppController.of(context)!.value('No file selected')}';
    }

  }
  Future<void> _pickFile() async {
    print('widget.isMultipleFiles>>>${widget.isMultipleFiles}');

    FilePickerResult? result;
    if (widget.isMultipleFiles!) {
      result = await FilePicker.platform.pickFiles(allowMultiple: true);
    } else {
      result = await FilePicker.platform.pickFiles();
    };


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
    if(_pickedFiles != null){
      for(var file in _pickedFiles!){
        print('mmmmmmmm>>>>${file.name}');
      }
      print('_pickedFiles>>>${_pickedFiles}');
    }

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
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.lable != null)Txt(widget.lable! , fontSize:16 , fontWeight: FontWeight.w400 , color: widget.lableColor,),
        if(widget.lable != null)SizedBox(height: 5,),
        InkWell(
          onTap: widget.disabled! ? null : _pickFile,
          child: Container(
         height: 48,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius != null ? widget.borderRadius : BorderRadius.all(Radius.circular(5)),
              border: Border.all(width: 1, color: widget.borderColor!),
            ),
            child: Row(
              children: [
                widget.disabled! ?fileBox(padding ,textStyle) :MouseRegion(
                onEnter: (_){
                 isHover.value = true;
                },
                onExit: (_){
                 isHover.value = false;
                },
                  child: Obx((){
                    return fileBox(padding , textStyle);
                  })
                ),
                Expanded(
                  child: Container(
                    height: 48,
                    padding: padding,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft:Radius.circular(5) , bottomLeft: Radius.circular(5)),
                      color:widget.disabled! ? color40: Colors.transparent,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Txt(getDisplayText() , fontSize: textStyle, fontWeight: FontWeight.w400, color: widget.fileTxtColor,),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget fileBox(padding , textStyle){
    return Container(
      padding: padding,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius != null ? widget.borderRadius! : BorderRadius.only(topRight:Radius.circular(5) , bottomRight: Radius.circular(5)),
        // borderRadius: BorderRadius.only(topRight:Radius.circular(5) , bottomRight: Radius.circular(5)),
        border: Border.all(width: 1, color: widget.borderColor!),
        color: isHover.value ? widget.fileTxtBoxHoverColor:widget.fileTxtBoxColor,
      ),
      child: Center(child: Txt(widget.fileTxt! , fontSize:textStyle, fontWeight: FontWeight.w400, color: widget.fileTxtColor,)),
    );
  }
}
