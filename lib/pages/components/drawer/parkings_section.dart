import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:parking_app/controllers/internet_connection_controller.dart';
import 'package:parking_app/controllers/parkings_controller.dart';

class ParkingsSection extends StatelessWidget {
  ParkingsSection({super.key});
  final _parkingsController = Get.find<ParkingsController>();
  final _internetConnectionController =
      Get.find<InternetConnectionController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25.0),
      child: Obx(
        () => _internetConnectionController.isConnected
            ? ListView(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: ParkingsSelection.values.map((parkingsSelection) {
                  return Row(
                    children: [
                      Switch(
                        activeTrackColor: const Color.fromARGB(255, 1, 136, 82),
                        value:
                            _parkingsController.selection == parkingsSelection,
                        onChanged: (value) {
                          if (!value) return;
                          _parkingsController.selection = parkingsSelection;
                          Future.delayed(const Duration(milliseconds: 350), () {
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      const SizedBox(width: 10.0),
                      Text(parkingsSelection.name),
                    ],
                  );
                }).toList(),
              )
            : Container(),
      ),
    );
  }
}
