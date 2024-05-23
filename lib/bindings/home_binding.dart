import 'package:get/get.dart';

import 'package:parking_app/controllers/buses_controller.dart';
import 'package:parking_app/controllers/internet_connection_controller.dart';
import 'package:parking_app/controllers/loading_controller.dart';
import 'package:parking_app/controllers/location_controller.dart';
import 'package:parking_app/controllers/parkings_controller.dart';
import 'package:parking_app/controllers/sidebar_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<InternetConnectionController>(
      InternetConnectionController(),
      permanent: true,
    );
    Get.put<LoadingController>(
      LoadingController(),
      permanent: true,
    );
    Get.put<ParkingsController>(
      ParkingsController(),
      permanent: true,
    );
    Get.put<BusesController>(
      BusesController(),
      permanent: true,
    );
    Get.lazyPut<SidebarController>(() => SidebarController());
    Get.lazyPut<LocationController>(() => LocationController());
  }
}
