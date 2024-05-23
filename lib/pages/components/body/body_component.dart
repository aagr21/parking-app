import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:parking_app/controllers/buses_controller.dart';
import 'package:parking_app/controllers/location_controller.dart';
import 'package:parking_app/controllers/parkings_controller.dart';
import 'package:parking_app/controllers/sidebar_controller.dart';
import 'package:parking_app/widgets/list_buttons.dart';

class BodyComponent extends StatelessWidget {
  BodyComponent({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  final _locationController = Get.find<LocationController>();
  final _flutterMapController = MapController();
  final _parkingsController = Get.find<ParkingsController>();
  final _sidebarController = Get.find<SidebarController>();
  final _busesController = Get.find<BusesController>();
  final _googleMapsUrl = 'https://www.google.com/maps/search/?api=1';
  final PopupController _popupController = PopupController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => PopupScope(
            popupController: _popupController,
            child: FlutterMap(
              mapController: _flutterMapController,
              options: MapOptions(
                initialCenter: const LatLng(-17.788223, -63.181640),
                initialZoom: 13.0,
                onTap: (tapPosition, point) {
                  _popupController.hideAllPopups();
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                  subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                ),
                if (_locationController.locationActive &&
                    _locationController.hasPermission && _locationController.position != null)
                  CurrentLocationLayer(
                    positionStream: _locationController.positionStream,
                  ),
                PopupMarkerLayer(
                  options: PopupMarkerLayerOptions(
                    markerCenterAnimation: const MarkerCenterAnimation(),
                    markers: _parkingsController.parkingsSelected
                        .map(
                          (parking) => Marker(
                            rotate: true,
                            point: LatLng(
                              parking.geom.coordinates[1],
                              parking.geom.coordinates[0],
                            ),
                            width: 22,
                            height: 22,
                            alignment: Alignment.topCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                color: parking.isFull
                                    ? const Color.fromARGB(255, 247, 14, 14)
                                    : const Color.fromARGB(255, 35, 184, 54),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3.0,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.local_parking,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    popupController: _popupController,
                    popupDisplayOptions: _parkingsController
                                .parkingsSelected.isNotEmpty &&
                            (_parkingsController.parkingSelected == null ||
                                _parkingsController.parkingsSelected
                                        .firstWhereOrNull((element) =>
                                            element.geom.coordinates[1] ==
                                                _parkingsController
                                                    .parkingSelected!
                                                    .geom
                                                    .coordinates[1] &&
                                            element.geom.coordinates[0] ==
                                                _parkingsController
                                                    .parkingSelected!
                                                    .geom
                                                    .coordinates[0]) !=
                                    null)
                        ? PopupDisplayOptions(
                            animation: const PopupAnimation.fade(
                              duration: Duration(milliseconds: 200),
                            ),
                            builder: (BuildContext context, Marker marker) {
                              final parking = _parkingsController
                                  .parkingsSelected
                                  .firstWhere(
                                (parking) =>
                                    parking.geom.coordinates[1] ==
                                        marker.point.latitude &&
                                    parking.geom.coordinates[0] ==
                                        marker.point.longitude,
                              );
                              _parkingsController.parkingSelected = parking;
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 280.0,
                                  height: 300.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(
                                      color: Colors.black38,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10.0,
                                        spreadRadius: 2.0,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 30.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (parking.imageUrl != null)
                                              Center(
                                                child: SizedBox(
                                                  height: 130.0,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(15.0),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          parking.imageUrl!,
                                                      placeholder:
                                                          (context, url) =>
                                                              const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                      errorListener: (value) {},
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                        Icons.error,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            const SizedBox(
                                              height: 15.0,
                                            ),
                                            if (parking.startAttention !=
                                                    null &&
                                                parking.endAttention != null)
                                              Container(
                                                padding: const EdgeInsets.only(
                                                  left: 30.0,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Horario de atención: ",
                                                          style: TextStyle(
                                                            fontSize: 12.2,
                                                          ),
                                                        ),
                                                        Text(
                                                          parking.startAttention ==
                                                                      "00:00" &&
                                                                  parking.endAttention ==
                                                                      "00:00"
                                                              ? "Siempre abierto"
                                                              : "${parking.startAttention} - ${parking.endAttention}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12.2,
                                                            color: parking.startAttention ==
                                                                        "00:00" &&
                                                                    parking.endAttention ==
                                                                        "00:00"
                                                                ? const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    18,
                                                                    160,
                                                                    70,
                                                                  )
                                                                : null,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Atención: ",
                                                          style: TextStyle(
                                                            fontSize: 12.2,
                                                          ),
                                                        ),
                                                        Text(
                                                          parking.startAttention ==
                                                                      "00:00" &&
                                                                  parking.endAttention ==
                                                                      "00:00"
                                                              ? "Siempre abierto"
                                                              : "Está ${DateTime.now().isAfter(DateTime.parse("${DateTime.now().toString().split(" ")[0]} ${parking.startAttention}")) && DateTime.now().isBefore(DateTime.parse("${DateTime.now().toString().split(" ")[0]} ${parking.endAttention}")) ? "abierto" : "cerrado"}",
                                                          style: TextStyle(
                                                            fontSize: 12.2,
                                                            color: parking.startAttention ==
                                                                        "00:00" &&
                                                                    parking.endAttention ==
                                                                        "00:00"
                                                                ? const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    18,
                                                                    160,
                                                                    70)
                                                                : DateTime.now().isAfter(DateTime.parse("${DateTime.now().toString().split(" ")[0]} ${parking.startAttention}")) &&
                                                                        DateTime.now().isBefore(DateTime.parse(
                                                                            "${DateTime.now().toString().split(" ")[0]} ${parking.endAttention}"))
                                                                    ? const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        18,
                                                                        160,
                                                                        70,
                                                                      )
                                                                    : Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Center(
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    const Color.fromARGB(
                                                        255, 18, 160, 70),
                                                  ),
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    Colors.white,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  launchUrl(
                                                    Uri.parse(
                                                      "$_googleMapsUrl&query=${parking.geom.coordinates[1]},${parking.geom.coordinates[0]}",
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  "Ver en Google Maps",
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            _popupController.hideAllPopups();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : null,
                  ),
                ),
                PolylineLayer(
                  polylines: [
                    if (_busesController.selectedBus != null)
                      Polyline(
                        points: _busesController.selectedBus!.geom.coordinates
                            .map(
                              (coordinate) =>
                                  LatLng(coordinate[1], coordinate[0]),
                            )
                            .toList(),
                        strokeWidth: 3.0,
                        color: Colors.red,
                      ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      onPressed: () async {
                        if (_locationController.hasPermission &&
                            _locationController.locationActive &&
                            _locationController.position != null) {
                          _flutterMapController.move(
                            LatLng(
                              _locationController.position!.latitude,
                              _locationController.position!.longitude,
                            ),
                            18.0,
                          );
                        } else {
                          _locationController.requestPermission();
                        }
                      },
                      tooltip: "Ubicación actual",
                      child: Icon(
                        _locationController.hasPermission &&
                                _locationController.locationActive
                            ? Icons.gps_fixed
                            : Icons.gps_not_fixed,
                        color: _locationController.hasPermission &&
                                _locationController.locationActive
                            ? const Color.fromARGB(255, 1, 136, 82)
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListButtons(
              direction: Axis.horizontal,
              spacing: 20.0,
              items: [
                ButtonItem(
                  child: const Icon(Icons.location_city),
                  onTap: () {
                    _flutterMapController.moveAndRotate(
                      const LatLng(-17.788223, -63.181640),
                      12.7,
                      0.0,
                    );
                  },
                ),
                ButtonItem(
                  child: const Icon(Icons.bus_alert_rounded),
                  onTap: () {
                    _sidebarController.selectedItem = DrawerItem.buses;
                    scaffoldKey.currentState!.openDrawer();
                  },
                ),
                ButtonItem(
                  child: const Icon(Icons.route),
                  onTap: () {},
                ),
                ButtonItem(
                  child: const Icon(Icons.local_parking_rounded),
                  onTap: () {
                    _sidebarController.selectedItem = DrawerItem.parkings;
                    scaffoldKey.currentState!.openDrawer();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
