import 'package:get/get.dart';
import 'package:parking_app/controllers/internet_connection_controller.dart';
import 'package:parking_app/controllers/loading_controller.dart';
import 'package:parking_app/models/bus.dart';
import 'package:parking_app/services/buses_services.dart';

class BusesController extends GetxController {
  final _searchText = ''.obs;
  String get searchText => _searchText.value;
  set searchText(String value) => _searchText.value = value;

  final _loadingController = Get.find<LoadingController>();
  final isConnectedRx = Get.find<InternetConnectionController>().isConnectedRx;

  final _showError = false.obs;
  bool get showError => _showError.value;
  set showError(bool value) => _showError.value = value;

  final _buses = <Bus>[].obs;
  List<Bus> get buses => _buses.toList();
  List<Bus> get filteredBuses => _buses
      .where(
        (bus) => bus.name.toLowerCase().contains(searchText.toLowerCase()),
      )
      .toList();

  final _selectedBus = Rx<BusRoute?>(null);
  BusRoute? get selectedBus => _selectedBus.value;
  set selectedBus(BusRoute? value) => _selectedBus.value = value;

  @override
  void onInit() {
    getBuses();
    isConnectedRx.listen((isConnected) {
      if (isConnected) {
        getBuses();
      } else {
        showError = true;
        _buses.clear();
        Future.delayed(const Duration(seconds: 5), () {
          showError = false;
        });
      }
    });
    super.onInit();
  }

  Future<void> getBuses() async {
    _loadingController.isLoading = true;
    final getBuses = await BusesServices.getBuses();
    if (getBuses != null) {
      _buses.assignAll(getBuses);
    } else {
      showError = true;
      Future.delayed(const Duration(seconds: 5), () {
        showError = false;
      });
    }
    _loadingController.isLoading = false;
  }

  Future<void> getBusRoute(String name, String ground) async {
    final getBus = await BusesServices.getBusRoute(name, ground);
    if (getBus != null) {
      selectedBus = getBus;
    }
  }
}
