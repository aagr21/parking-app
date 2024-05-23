import 'package:get/get.dart';

import 'package:parking_app/bindings/home_binding.dart';
import 'package:parking_app/pages/home_page.dart';

class Routes {
  static const String home = '/';
}

class Pages {
  static final pages = [
    GetPage(
      name: Routes.home,
      page: () => const HomePage(title: 'Parqueos'),
      binding: HomeBinding(),
    ),
  ];
}
