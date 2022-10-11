
import 'package:get/get.dart';
import 'package:interview/src/ui/saved_contacts.dart';

import '../../bindings/home_binding.dart';
import '../../ui/home_ui.dart';
import 'app_routes.dart';

class AppPages {
  static String initialRoute = AppRoutes.homePage;
  static final routes = [

    GetPage(
        name: AppRoutes.homePage,
        page: () => const Home(),
        binding: HomeBinding()),
    GetPage(

        name: AppRoutes.savedContacts,
        page: () => const SavedContacts(),
       ),
  ];
}
