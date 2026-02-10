import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class FilePickerController extends GetxController {

  static Future<String?> pickAndSaveLocalFile({required PlatformFile file, required String tableName,}) async {
    // مسیر حافظه داخلی اپ
    final appDir = await getApplicationDocumentsDirectory();
    final tableDir = Directory('${appDir.path}/$tableName');
    // ساخت پوشه اگر وجود نداشت
    if (!await tableDir.exists()) {
      await tableDir.create(recursive: true);
    }

    // اگر مسیر فایل نال بود
    if (file.path == null) {
      return null;
    }
    // final uuid = const Uuid().v4();
    final newPath = '${tableDir.path}/${file.name}';
    final savedFile = await File(file.path!).copy(newPath);
    print('FilePickerController.pickAndSaveLocalFile>>>${savedFile.path}');
    return savedFile.path;
  }
  static  convertToBase64(String data)async{
    final bytes = await  File(data).readAsBytes();
    return bytes;
  }
}
