import 'package:file_picker/file_picker.dart';
import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class FormFile extends StatefulWidget {
  Function(List<dynamic>)? onChanged;
  Map<String,  List<dynamic>> filesSelected;
  String? columnName;
  var selectedFilesTxt;
  var column;


  FormFile({this.onChanged ,required this.filesSelected , this.columnName , this.selectedFilesTxt , this.column});

  @override
  State<FormFile> createState() => _FormFileState();
}

class _FormFileState extends State<FormFile> {
  var selectedFiles = null;
  String _errorMasege='';
  Rx<bool>? isSeletedFile = false.obs;
  List<int> fileSizeList=[];

  @override
  Widget build(BuildContext context) {
    var inputRequired = widget.column['validators'].firstWhere((validator) => validator['type'] == 'required', orElse: () => null);
    if(widget.filesSelected['${widget.columnName}'] == null){
      widget.filesSelected['${widget.columnName}']=[];
    }
    return Obx((){
      if(ViewController.isShowMessage.value == true){
        if(inputRequired != null){
          if(this.isSeletedFile!.value == false){
            _errorMasege = inputRequired['message'];
          }
        }
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () async {
                  var picked = await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'pdf', 'doc' , 'png'],
                  );
                  if (picked != null) {
                    setState(() {
                      this.isSeletedFile!.value = true;
                    });
                    var maxValidator = widget.column['validators'].firstWhere((validator) => validator['type'] == 'max', orElse: () => null);
                    var minValidator = widget.column['validators'].firstWhere((validator) => validator['type'] == 'min', orElse: () => null);
                    for(var file in picked.files){
                      var maxSize = maxValidator['value'];
                      var minSize = minValidator['value'];
                      fileSizeList.add(file.size);
                      ViewController.fileSizeList['${widget.column['name']}'] = fileSizeList;
                        //check min and max
                        if(file.size <  maxSize && file.size > minSize){
                          bool fileExists = widget.filesSelected['${widget.columnName}']!.any((existingFile) =>
                          existingFile['name'] == file.name.substring(0, file.name.lastIndexOf('.')) &&
                              existingFile['extension'] == file.extension);
                          if(!fileExists){
                            widget.filesSelected['${widget.columnName}']!.add({
                              'name': file.name.substring(0, file.name.lastIndexOf('.')),
                              'extension': file.extension,
                              'size': file.size,
                            });
                          }
                          selectedFiles = widget.filesSelected['${widget.columnName}']!;
                          setState(() {
                            _errorMasege = '';
                          });
                        }
                        else{
                          setState(() {
                            // String? errorMessage;
                            // var inputRange = widget.column['validators'].firstWhere((validator) => validator['type'] == 'range', orElse: () => null);
                            // if(inputRange != null){
                            //   errorMessage = inputRange['message'];
                            // }
                            // _errorMasege = '${errorMessage}';
                            if(file.size <  minSize){
                              setState(() {
                                _errorMasege = minValidator['message'];
                              });
                            }
                            else{
                              if(file.size > maxSize){
                                setState(() {
                                  _errorMasege = maxValidator['message'];
                                });
                              }
                              else{
                                setState(() {
                                  _errorMasege = '';
                                });
                              }
                            }
                          });
                        }
                      if(widget.filesSelected['${widget.columnName}']!.length == 0){
                        widget.selectedFilesTxt = [];
                        selectedFiles = widget.selectedFilesTxt;
                      }
                      else{
                        widget.selectedFilesTxt = widget.filesSelected['${widget.columnName}']!;
                        selectedFiles = widget.selectedFilesTxt;
                      }
                    }
                    if (widget.onChanged != null) {
                      widget.onChanged!(widget.filesSelected['${widget.columnName}']!);
                    }
                  }
                  else{
                    if(inputRequired != null){
                      setState(() {
                        _errorMasege = inputRequired['message'];
                      });
                    }
                  }
                },
                child: Container(
                  color: colorBtn,
                  padding: EdgeInsets.all(15),
                  child: Txt('${AppController.of(context)!.value('Please select the desired file')}' , fontSize: 16 , fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(width: 5,),
              Obx((){
                return Expanded(child: Txt('${selectedFiles  == null?widget.filesSelected['${widget.columnName}']!.length != 0 ? widget.filesSelected['${widget.columnName}']! :'':selectedFiles }' , color: MainController.isLightMode.value ? whiteColor : primaryDark  ,));
              })
            ],
          ),
          SizedBox(height: 5,),
          Txt('${_errorMasege != ''? _errorMasege:''}' , color: errorColor,),
        ],
      );
    });
  }
}
