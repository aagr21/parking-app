import 'dart:async';

import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionController extends GetxController {
  final isConnectedRx = false.obs;
  bool get isConnected => isConnectedRx.value;
  late final StreamSubscription<InternetCheckResult> _subscription;

  @override
  void onInit() {
    super.onInit();
    checkInternetConnection();
  }

  void checkInternetConnection() async {
    isConnectedRx.value = await InternetConnection().hasInternetAccess;
    InternetConnection().onStatusChange.listen((status) {
      isConnectedRx.value = status == InternetStatus.connected;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
