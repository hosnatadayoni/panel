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
  Function(String)? onChanged;
  Map<String,  List<dynamic>> filesSelected;
  String? columnName;
  var selectedFilesTxt;
  var column;
  Rx<bool>? isSeletedFile = false.obs;
  var file;
  RxMap<String, List<dynamic>> fileInfo = <String, List<dynamic>>{}.obs;



  FormFile({this.onChanged ,required this.filesSelected , this.columnName , this.selectedFilesTxt , this.column , this.isSeletedFile , this.file , required this.fileInfo});

  @override
  State<FormFile> createState() => _FormFileState();
}

class _FormFileState extends State<FormFile> {
  var selectedFiles = null;
  String _errorMasege='';

  List<int> fileSizeList=[];
  var filePath;
  List<String> fileNameList=[];
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
      // print('bbbbbbbbb>>>${MainController.chunckCurrentIndex.value}');
      print('pppppppppps>>>${widget.fileInfo.value}');
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
          if(widget.column['type'] == 'multifile' ||( widget.column['type'] == 'file' && fileNameList.length == 0))
            InkWell(
            onTap: () async {
              var picked = await FilePicker.platform.pickFiles(
                allowMultiple: widget.column['type'] == 'multifile' ? true: false,
                type: FileType.custom,
                withReadStream: true,
                withData: true,
                allowedExtensions: widget.column['isPictureSelected'] != null && widget.column['isPictureSelected'] == true ? ['jpg', 'png']:['jpg', 'pdf', 'doc' , 'png'],
              );
              print('picked>>>${picked}');
              for(var file in picked!.files){
                if(!fileNameList.contains(file.name)){
                  fileNameList.add(file.name);
                }
              }

              filePath= await MainController.uploadFileInChunks(picked,widget.column , widget.fileInfo);
              print('filePath>>>${filePath}');

              if (picked != null) {
                setState(() {
                  widget.isSeletedFile!.value = true;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(filePath);
                }
              }
            },
            child: Container(
              width: 280,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: MainController.isLightMode.value == true ? whiteColor : color2,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.cloud_upload_outlined, size: 50,),
                  SizedBox(width: 10),
                  Txt('برای انتخاب فایل کلیک کنید',fontSize: 16, color: blackColor,),
                ],
              ),
            ),
          ),
          SizedBox(height: 15,),
          Column(
            children: [
              for(var i=0;i<fileNameList.length;i++)
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                  children: [
                    Icon(
                      Icons.insert_drive_file,
                      size: 40,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 5,),
                    Obx((){
                      var fileData = widget.fileInfo[fileNameList[i]];
                      var totalChunks = fileData?[0] ?? 1;
                      var currentChunk = fileData?[1] ?? 0;
                      var progressValue = totalChunks > 0 ? currentChunk / totalChunks : 0;
                      print('fileData>>>${fileData}');
                      print('totalChunks>>>${totalChunks}');
                      print('currentChunk>>>${currentChunk}');
                      print('progressValue>>>${progressValue}');
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Txt(
                                '${fileNameList[i]}',
                                fontSize: 16,
                                color: totalChunks== currentChunk ? Colors.white : Colors.grey,
                              ),
                              if(totalChunks== currentChunk)
                                IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder:
                                          (BuildContext context) {
                                        return Dialog(
                                            child: Container(
                                              width: 150,
                                              height: 150,
                                              padding:
                                              EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        10)),
                                              ),
                                              child: Column(
                                                children: [
                                                  Txt('${AppController.of(context)!.value('Do you want this item to be removed?')}'),
                                                  Spacer(),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                        Container(
                                                          padding:
                                                          EdgeInsets
                                                              .all(
                                                              15),
                                                          width: 52,
                                                          height: 52,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.all(Radius.circular(
                                                                  10)),
                                                              color:
                                                              redColor),
                                                          child: Center(
                                                              child:
                                                              Txt(
                                                                '${AppController.of(context)!.value('no')}',
                                                                color:
                                                                whiteColor,
                                                              )),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      InkWell(
                                                        onTap:
                                                            () async {

                                                          await MainController.deleteFileInChunks(filePath);
                                                          setState(() {
                                                            fileNameList.removeAt(i);
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        child:
                                                        Container(
                                                          padding:
                                                          EdgeInsets
                                                              .all(
                                                              15),
                                                          width: 52,
                                                          height: 52,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.all(Radius.circular(
                                                                  10)),
                                                              color:
                                                              successColor),
                                                          child: Center(
                                                              child:
                                                              Txt(
                                                                '${AppController.of(context)!.value('yes')}',
                                                                color:
                                                                whiteColor,
                                                              )),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ));
                                      });
                                },
                              )
                            ],
                          ),
                          currentChunk != 0 ?
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: SizedBox(
                              width: 200,
                              child: LinearProgressIndicator(
                                value:totalChunks > 0 ? currentChunk / totalChunks : 0,
                                backgroundColor: Colors.grey,
                                minHeight: 5,
                                color: totalChunks == currentChunk
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ) : Container(),
                        ],
                      );
                    })
                  ],
              ),
                ),
            ],
          ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     InkWell(
            //       onTap: () async {
            //
            //         print('selected file');
            //         var picked = await FilePicker.platform.pickFiles(
            //           allowMultiple: true,
            //           type: FileType.custom,
            //           withReadStream: true,
            //           withData: true,
            //           allowedExtensions: widget.column['isPictureSelected'] != null && widget.column['isPictureSelected'] == true ? ['jpg', 'png']:['jpg', 'pdf', 'doc' , 'png'],
            //         );
            //         print('picked>>>${picked}');
            //
            //         filePath= await MainController.uploadFileInChunks(picked,widget.column);
            //
            //         if (picked != null) {
            //           setState(() {
            //                 widget.isSeletedFile!.value = true;
            //               });
            //           if (widget.onChanged != null) {
            //                 widget.onChanged!(filePath);
            //               }
            //         }
            //         //
            //         // }
            //         //   setState(() {
            //         //     widget.isSeletedFile!.value = true;
            //         //   });
            //         //   var maxValidator;
            //         //   var minValidator;
            //         //   if(widget.column['validators'] != null){
            //         //     maxValidator  = widget.column['validators'].firstWhere((validator) => validator['type'] == 'max', orElse: () => null);
            //         //     minValidator = widget.column['validators'].firstWhere((validator) => validator['type'] == 'min', orElse: () => null);
            //         //   }
            //         //
            //         //
            //         //   for(var file in picked.files){
            //         //     print('_FormFileState.build>>${file.bytes}>>${file.extension}>>${file.readStream}>>}>>');
            //         //           var maxSize;
            //         //     var minSize;
            //         //     if(maxValidator != null || minValidator != null){
            //         //       maxSize = maxValidator['value'];
            //         //       minSize = minValidator['value'];
            //         //       fileSizeList.add(file.size);
            //         //       ViewController.fileSizeList['${widget.column['name']}'] = fileSizeList;
            //         //       //check min and max
            //         //       if(file.size <  maxSize && file.size > minSize){
            //         //         bool fileExists = widget.filesSelected['${widget.columnName}']!.any((existingFile) =>
            //         //         existingFile['name'] == file.name.substring(0, file.name.lastIndexOf('.')) &&
            //         //             existingFile['extension'] == file.extension);
            //         //         if(!fileExists){
            //         //           widget.filesSelected['${widget.columnName}']!.add({
            //         //             'name': file.name.substring(0, file.name.lastIndexOf('.')),
            //         //             'extension': file.extension,
            //         //             'size': file.size,
            //         //           });
            //         //         }
            //         //         selectedFiles = widget.filesSelected['${widget.columnName}']!;
            //         //         setState(() {
            //         //           _errorMasege = '';
            //         //         });
            //         //       }
            //         //       else{
            //         //         setState(() {
            //         //           // String? errorMessage;
            //         //           // var inputRange = widget.column['validators'].firstWhere((validator) => validator['type'] == 'range', orElse: () => null);
            //         //           // if(inputRange != null){
            //         //           //   errorMessage = inputRange['message'];
            //         //           // }
            //         //           // _errorMasege = '${errorMessage}';
            //         //           if(file.size <  minSize){
            //         //             setState(() {
            //         //               _errorMasege = minValidator['message'];
            //         //             });
            //         //           }
            //         //           else{
            //         //             if(file.size > maxSize){
            //         //               setState(() {
            //         //                 _errorMasege = maxValidator['message'];
            //         //               });
            //         //             }
            //         //             else{
            //         //               setState(() {
            //         //                 _errorMasege = '';
            //         //               });
            //         //             }
            //         //           }
            //         //         });
            //         //       }
            //         //       if(widget.filesSelected['${widget.columnName}']!.length == 0){
            //         //         widget.selectedFilesTxt = [];
            //         //         selectedFiles = widget.selectedFilesTxt;
            //         //       }
            //         //       else{
            //         //         widget.selectedFilesTxt = widget.filesSelected['${widget.columnName}']!;
            //         //         selectedFiles = widget.selectedFilesTxt;
            //         //       }
            //         //     }
            //         //     else{
            //         //       _errorMasege = '';
            //         //       fileSizeList.add(file.size);
            //         //       ViewController.fileSizeList['${widget.column['name']}'] = fileSizeList;
            //         //
            //         //
            //         //       bool fileExists = widget.filesSelected['${widget.columnName}']!.any((existingFile) =>
            //         //       existingFile['name'] == file.name.substring(0, file.name.lastIndexOf('.')) &&
            //         //           existingFile['extension'] == file.extension);
            //         //       if(!fileExists){
            //         //         widget.filesSelected['${widget.columnName}']!.add({
            //         //           'name': file.name.substring(0, file.name.lastIndexOf('.')),
            //         //           'extension': file.extension,
            //         //           'size': file.size,
            //         //         });
            //         //       }
            //         //       selectedFiles = widget.filesSelected['${widget.columnName}']!;
            //         //
            //         //       if(widget.filesSelected['${widget.columnName}']!.length == 0){
            //         //         widget.selectedFilesTxt = [];
            //         //         selectedFiles = widget.selectedFilesTxt;
            //         //       }
            //         //       else{
            //         //         widget.selectedFilesTxt = widget.filesSelected['${widget.columnName}']!;
            //         //         selectedFiles = widget.selectedFilesTxt;
            //         //       }
            //         //     }
            //         //   }
            //         //   if (widget.onChanged != null) {
            //         //     widget.onChanged!(widget.filesSelected['${widget.columnName}']!);
            //         //   }
            //         // }
            //         // else{
            //         //   if(inputRequired != null){
            //         //     setState(() {
            //         //       if(widget.filesSelected['${widget.columnName}']!.length == 0){
            //         //         _errorMasege = inputRequired['message'];
            //         //       }
            //         //
            //         //     });
            //         //   }
            //         // }
            //       },
            //       child: Container(
            //         color: colorBtn,
            //         padding: EdgeInsets.all(15),
            //         child: Txt('${AppController.of(context)!.value('Please select the desired file')}' , fontSize: 16 , fontWeight: FontWeight.w400),
            //       ),
            //     ),
            //     SizedBox(width: 5,),
            //     Obx((){
            //       return
            //         Expanded(child: Txt('${selectedFiles  == null?widget.filesSelected['${widget.columnName}']!.length != 0 ? widget.filesSelected['${widget.columnName}']! :'':selectedFiles }' , color: MainController.isLightMode.value ? whiteColor : primaryDark  ,));
            //     }),
            //     if(widget.isSeletedFile!.value)
            //        InkWell(
            //          onTap: (){
            //            print('_FormFileState.build>>${widget.column['name']}>>${ViewController.request[widget.column['name']]}');
            //                 MainController.deleteFileInChunks(ViewController.request[widget.column['name']]);
            //          },
            //          child:  Icon(Icons.delete,color: Colors.red,),
            //        )
            //
            //   ],
            // ),

          SizedBox(height: 5,),
          Txt('${_errorMasege != ''? _errorMasege:''}' , color: errorColor,),

        ],
      );
    });
  }
}
