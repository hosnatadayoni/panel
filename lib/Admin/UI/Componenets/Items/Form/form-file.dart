import 'package:file_picker/file_picker.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class FormFile extends StatefulWidget {
  Function(List<dynamic>)? onChanged;
  Map<String,  List<dynamic>> filesSelected;
  String? columnName;
  var selectedFilesTxt;
  var column;
  Rx<bool>? isSeletedFile = false.obs;
  var file;



  FormFile({this.onChanged ,required this.filesSelected , this.columnName , this.selectedFilesTxt , this.column , this.isSeletedFile , this.file});

  @override
  State<FormFile> createState() => _FormFileState();
}

class _FormFileState extends State<FormFile> {
  var selectedFiles = null;
  String _errorMasege='';

  List<int> fileSizeList=[];

  @override
  Widget build(BuildContext context) {
    var inputRequired;
    if(widget.column['validators'] != null){
      inputRequired = widget.column['validators'].firstWhere((validator) => validator['type'] == 'required', orElse: () => null);
      if(widget.filesSelected['${widget.columnName}'] == null){
        widget.filesSelected['${widget.columnName}']=[];
      }
    }

    return Obx((){
      if(ViewController.isClickedBtn.value == true || ViewController.isClickedEditBtn.value == true){
        if(inputRequired != null){
          if(widget.isSeletedFile!.value == false){
            _errorMasege = inputRequired['message'];
          }
        }
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(MainController.selectedSubItem.value != -1)
            MainController.SubMenuList[MainController.selectedSubItem.value]['view'] != 'custom' ?
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    print('selected file');
                    var picked = await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType.custom,
                      withReadStream: true,
                      allowedExtensions: widget.column['isPictureSelected'] != null && widget.column['isPictureSelected'] == true ? ['jpg', 'png']:['jpg', 'pdf', 'doc' , 'png'],
                    );
                    print('picked>>>${picked}');
                    if (picked != null) {

                      setState(() {
                        widget.isSeletedFile!.value = true;
                      });
                      var maxValidator;
                      var minValidator;
                      if(widget.column['validators'] != null){
                        maxValidator  = widget.column['validators'].firstWhere((validator) => validator['type'] == 'max', orElse: () => null);
                        minValidator = widget.column['validators'].firstWhere((validator) => validator['type'] == 'min', orElse: () => null);
                      }

                      for(var file in picked.files){
                        var maxSize;
                        var minSize;
                        if(maxValidator != null || minValidator != null){
                          maxSize = maxValidator['value'];
                          minSize = minValidator['value'];
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
                        else{
                          _errorMasege = '';
                          fileSizeList.add(file.size);
                          ViewController.fileSizeList['${widget.column['name']}'] = fileSizeList;


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

                          if(widget.filesSelected['${widget.columnName}']!.length == 0){
                            widget.selectedFilesTxt = [];
                            selectedFiles = widget.selectedFilesTxt;
                          }
                          else{
                            widget.selectedFilesTxt = widget.filesSelected['${widget.columnName}']!;
                            selectedFiles = widget.selectedFilesTxt;
                          }
                        }
                        // MainController.upload(file);
                      }
                      if (widget.onChanged != null) {
                        widget.onChanged!(widget.filesSelected['${widget.columnName}']!);
                      }
                    }
                    else{
                      if(inputRequired != null){
                        setState(() {
                          if(widget.filesSelected['${widget.columnName}']!.length == 0){
                            _errorMasege = inputRequired['message'];
                          }

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
                  return
                    Expanded(child: Txt('${selectedFiles  == null?widget.filesSelected['${widget.columnName}']!.length != 0 ? widget.filesSelected['${widget.columnName}']! :'':selectedFiles }' , color: MainController.isLightMode.value ? whiteColor : primaryDark  ,));
                })
              ],
            ):Wrap(
              children: [
                InkWell(
                  onTap: () async {
                    var picked = await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      withReadStream: true,
                      type: FileType.custom,
                      allowedExtensions: widget.column['isPictureSelected'] != null && widget.column['isPictureSelected'] == true ? ['jpg', 'png']:['jpg', 'pdf', 'doc' , 'png'],
                    );
                    print('picked custom>>>${picked}');
                    if (picked != null) {
                      setState(() {
                        widget.isSeletedFile!.value = true;
                      });
                      var maxValidator;
                      var minValidator;
                      if(widget.column['validators'] != null){
                        maxValidator  = widget.column['validators'].firstWhere((validator) => validator['type'] == 'max', orElse: () => null);
                        minValidator = widget.column['validators'].firstWhere((validator) => validator['type'] == 'min', orElse: () => null);
                      }

                      for(var file in picked.files){
                        var maxSize;
                        var minSize;
                        if(maxValidator != null || minValidator != null){
                          maxSize = maxValidator['value'];
                          minSize = minValidator['value'];
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
                        else{
                          _errorMasege = '';
                          fileSizeList.add(file.size);
                          ViewController.fileSizeList['${widget.column['name']}'] = fileSizeList;


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

                          if(widget.filesSelected['${widget.columnName}']!.length == 0){
                            widget.selectedFilesTxt = [];
                            selectedFiles = widget.selectedFilesTxt;
                          }
                          else{
                            widget.selectedFilesTxt = widget.filesSelected['${widget.columnName}']!;
                            selectedFiles = widget.selectedFilesTxt;
                          }
                        }
                        // MainController.upload(file);

                      }
                      if (widget.onChanged != null) {
                        widget.onChanged!(widget.filesSelected['${widget.columnName}']!);
                      }
                    }
                    else{
                      if(inputRequired != null){
                        setState(() {
                          if(widget.filesSelected['${widget.columnName}']!.length == 0){
                            _errorMasege = inputRequired['message'];
                          }

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
                  return
                    Txt('${selectedFiles  == null?widget.filesSelected['${widget.columnName}']!.length != 0 ? widget.filesSelected['${widget.columnName}']! :'':selectedFiles }' , color: MainController.isLightMode.value ? whiteColor : primaryDark  ,);
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
