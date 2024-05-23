import 'package:get/get.dart';
import 'package:parking_app/models/bus.dart';
import 'package:parking_app/services/buses_services.dart';

enum DrawerItem { buses, parkings }

extension DrawerItemExtension on DrawerItem {
  String get title {
    switch (this) {
      case DrawerItem.buses:
        return 'Micros de la Ciudad (rutas)';
      case DrawerItem.parkings:
        return 'Estacionamientos';
    }
  }
}

class SidebarController extends GetxController {
  final _selectedItem = DrawerItem.buses.obs;
  DrawerItem get selectedItem => _selectedItem.value;
  set selectedItem(DrawerItem value) => _selectedItem.value = value;

  final buses = <Bus>[].obs;

  @override
  void onInit() {
    getBuses();
    super.onInit();
  }

  Future<void> getBuses() async {
    final buses = await BusesServices.getBuses();
    if (buses != null) {
      this.buses.assignAll(buses);
    }
  }
}
