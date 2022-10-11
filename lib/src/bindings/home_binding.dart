import 'package:get/get.dart';
import 'package:interview/src/controller/home_controller.dart';

class HomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(HomeController());
  }

}