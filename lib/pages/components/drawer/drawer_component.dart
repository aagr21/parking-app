import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:parking_app/controllers/sidebar_controller.dart';
import 'package:parking_app/pages/components/drawer/buses_section.dart';
import 'package:parking_app/pages/components/drawer/parkings_section.dart';

class DrawerComponent extends StatelessWidget {
  DrawerComponent({
    super.key,
    required this.scaffoldKey,
  });

  final _sidebarController = Get.find<SidebarController>();
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 335,
      child: Obx(
        () => Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 200,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 1, 136, 82),
                ),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 80.0,
                      width: 80.0,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Image(
                        image: AssetImage('assets/images/logo-SMTT.png'),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _sidebarController.selectedItem.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _sidebarController.selectedItem == DrawerItem.buses
                ? Expanded(
                    child: BusesSection(),
                  )
                : ParkingsSection(),
          ],
        ),
      ),
    );
  }
}
