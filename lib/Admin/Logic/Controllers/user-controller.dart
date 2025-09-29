import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../Public/api-urls.dart';
import '../../UI/Views/dashboard.dart';
import '../Helpers/api-methods.dart';
import '../Helpers/token-methods.dart';
import 'main-controller.dart';

class UserController extends GetxController {
  static Rx<String> userName = ''.obs;
  static Rx<String> password = ''.obs;
  static String? userId;
  static Rx<bool> isVisibility = true.obs;

  static login() async {
    var response = await RestApi.post(loginUrl,
        body: {'username': userName.value, 'password': password.value,'api_key': MainController.apiKey.value},useToken: false);
    RestApi.responseHandler(
        response: response,

        successCallback: () async {
          var user = response!.data['data'];
          if (user != null) {
            await Token.setToken(user['token']!);
            Get.to(DashboardPage());
          }
        },
        printResponse: true,);
  }
}
