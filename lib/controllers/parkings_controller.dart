import 'package:get/get.dart';
import 'package:parking_app/controllers/internet_connection_controller.dart';
import 'package:parking_app/models/parking.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum ParkingsSelection { hidden, all, free, occupied }

extension ParkingsSelectionExtension on ParkingsSelection {
  String get name {
    switch (this) {
      case ParkingsSelection.hidden:
        return 'Ocultar';
      case ParkingsSelection.all:
        return 'Todos';
      case ParkingsSelection.free:
        return 'Libres';
      case ParkingsSelection.occupied:
        return 'Ocupados';
    }
  }
}

class ParkingsController extends GetxController {
  final parkings = <Parking>[].obs;
  final socket =
      io.io('https://parqueos-api.adaptable.app/parking', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  final _selection = ParkingsSelection.hidden.obs;
  ParkingsSelection get selection => _selection.value;
  set selection(ParkingsSelection value) => _selection.value = value;

  Rx<Parking?> _parkingSelected = Rx<Parking?>(null);
  Parking? get parkingSelected => _parkingSelected.value;
  set parkingSelected(Parking? value) {
    _parkingSelected = value.obs;
  }

  final isConnectedRx = Get.find<InternetConnectionController>().isConnectedRx;

  List<Parking> get parkingsSelected {
    switch (selection) {
      case ParkingsSelection.all:
        return parkingsAll;
      case ParkingsSelection.free:
        return parkingsFree;
      case ParkingsSelection.occupied:
        return parkingsOccupied;
      case ParkingsSelection.hidden:
        return [];
    }
  }

  List<Parking> get parkingsAll => parkings;
  List<Parking> get parkingsFree =>
      parkings.where((element) => !element.isFull).toList();
  List<Parking> get parkingsOccupied =>
      parkings.where((element) => element.isFull).toList();

  @override
  void onInit() {
    socket.onConnect((data) {});
    socket.on('update', (data) {
      parkings.clear();
      parkings.addAll(parkingsFromJsonList(data));
    });
    socket.onDisconnect((data) {});
    super.onInit();
  }

  @override
  void onClose() {
    socket.disconnect();
    super.onClose();
  }
}
