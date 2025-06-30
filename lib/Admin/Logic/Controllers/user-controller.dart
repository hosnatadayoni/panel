import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UserController extends GetxController{
  static Rx<String> userName=''.obs;
  static Rx<String> password = ''.obs;
  static Rx<bool>isVisibility = true.obs;

}