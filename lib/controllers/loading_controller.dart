import 'package:get/get.dart';

class LoadingController extends GetxController {
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
}