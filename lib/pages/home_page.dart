import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:parking_app/controllers/buses_controller.dart';

import 'package:parking_app/controllers/loading_controller.dart';
import 'package:parking_app/pages/components/app_bar/app_bar.dart';
import 'package:parking_app/pages/components/body/body_component.dart';
import 'package:parking_app/pages/components/drawer/drawer_component.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _loadingController = Get.find<LoadingController>();
  final _busesController = Get.find<BusesController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            key: _scaffoldKey,
            appBar: const MyAppBar(
              title: 'Santa Cruz de la Sierra',
            ),
            drawer: DrawerComponent(
              scaffoldKey: _scaffoldKey,
            ),
            body: BodyComponent(
              scaffoldKey: _scaffoldKey,
            ),
          ),
          if (_loadingController.isLoading)
            const Opacity(
              opacity: 0.6,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (_loadingController.isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 7, 199, 52),
              ),
            ),
          if (_busesController.showError)
            Container(
              alignment: Alignment.center,
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.6),
              child: Container(
                width: 260,
                height: 200,
                alignment: Alignment.center,
                child: const Card(
                  elevation: 5,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 35),
                    child: Text(
                      'No se pudo conectar.\nRevise su conexión a internet o inténtelo más tarde.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
