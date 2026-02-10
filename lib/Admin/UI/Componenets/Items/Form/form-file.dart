import 'package:file_picker/file_picker.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/validator-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/tableModel.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../Logic/Controllers/filePicker-controller.dart';
import '../../../../Logic/Models/columnModel.dart';
import '../../Popups/snackbar.dart';

class FormFile extends StatefulWidget {
  Function(String)? onChanged;
  Map<String, List<dynamic>> filesSelected;
  String? columnName;
  var selectedFilesTxt;
  ColumnModel? column;
  Rx<bool>? isSeletedFile = false.obs;
  var file;
  RxMap<String, List<dynamic>> fileInfo = <String, List<dynamic>>{}.obs;

  FormFile(
      {this.onChanged,
      required this.filesSelected,
      this.columnName,
      this.selectedFilesTxt,
      this.column,
      this.isSeletedFile,
      this.file,
      required this.fileInfo});

  @override
  State<FormFile> createState() => _FormFileState();
}

class _FormFileState extends State<FormFile> {
  var selectedFiles = null;
  String _errorMasege = '';

  List<int> fileSizeList = [];
  Rx<String> filePath = ''.obs;
  RxList<String> fileNameList = <String>[].obs;

  @override
  Widget build(BuildContext context) {
    var inputRequired;
    if (widget.column!.validators.length != 0) {
      inputRequired = widget.column!.validators.firstWhere(
          (validator) => validator['type'] == 'required',
          orElse: () => null);
      if (widget.filesSelected['${widget.columnName}'] == null) {
        widget.filesSelected['${widget.columnName}'] = [];
      }
    }
    return Obx(() {
      if (ViewController.isClickedBtn.value == true ||
          ViewController.isClickedEditBtn.value == true) {
        if (inputRequired != null) {
          if (widget.isSeletedFile!.value == false) {
            _errorMasege = inputRequired['message'];
          }
        }
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.column!.type == 'multiFile' ||
              widget.column!.type == 'multiFile_pv' ||
              ((widget.column!.type == 'file' ||
                      widget.column!.type == 'file_pv') &&
                  fileNameList.length == 0))
            InkWell(
              onTap: () async {
                FilePickerResult? picked = await FilePicker.platform.pickFiles(
                  allowMultiple: widget.column!.type == 'multiFile' ||
                          widget.column!.type == 'multiFile_pv'
                      ? true
                      : false,
                  type: FileType.custom,
                  withReadStream: true,
                  withData: true,
                  allowedExtensions: widget.column!.isPictureSelected != null &&
                          widget.column!.isPictureSelected == true
                      ? ['jpg', 'png']
                      : ['jpg', 'pdf', 'doc', 'png'],
                );

                if (picked != null) {
                  for (PlatformFile file in picked.files) {

                    var [validation, message] =
                        ValidatorController.validationFile(
                            widget.column!, file);
                    if (validation == false) {
                      fileNameList.removeWhere((element) => element == file.name);
                      showSnackbar(snackTypes.error, '${message}');
                    } else {

                      var tableStatus = MainController.getInfoTableById(widget.column!.myTable!).schema.online;
                      if (tableStatus == true) {
                if (!fileNameList.contains(file.name)) {
                fileNameList.add(file.name);
                }
                        filePath.value =(await MainController.uploadFileInChunks(file, widget.column!, widget.fileInfo))!;
                      } else {
                        String tableName = MainController.getTableNameById(widget.column!.myTable!);
                        var path =await FilePickerController.pickAndSaveLocalFile(file: file,tableName: tableName,);
                        filePath.value = path!=null?path:'';
                if (!fileNameList.contains(filePath.value)) {
                fileNameList.add(filePath.value);
                }
                      }
                    }
                    if( filePath.value!='') {
                      setState(() {
                        widget.isSeletedFile!.value = true;
                      });
                      if (widget.onChanged != null) {
                        widget.onChanged!(filePath.value);
                      }
                    }
                  }

                }
              },
              child: IntrinsicWidth(
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: MainController.isLightMode.value == true
                          ? background
                          : whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: MainController.isLightMode.value == true
                              ? whiteColor
                              : background,
                          width: 0.5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 30,
                        color: MainController.isLightMode.value == true
                            ? whiteColor
                            : blackColor,
                      ),
                      SizedBox(width: 10),
                      Txt(
                        '${AppController.of(context)!.value('Select file')}',
                        fontSize: 12,
                        color: MainController.isLightMode.value == true
                            ? whiteColor
                            : blackColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          SizedBox(
            height: 15,
          ),
          Column(
            children: [
              for (var i = 0; i < fileNameList.length; i++)
                FutureBuilder<Widget>(
                  future: ViewController.generateSelectFileBox(
                      widget.column!, fileNameList, widget.fileInfo, i),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // or SizedBox()
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return snapshot.data!;
                    }
                  },
                ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Txt(
            '${_errorMasege != '' ? _errorMasege : ''}',
            color: errorColor,
          ),
        ],
      );
    });
  }
}
