import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SelectFieldController extends GetxController {
  static Rx<String> sourceSelected = ''.obs;
  static Rx<String> sourceItem = ''.obs;
}