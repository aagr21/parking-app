import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:parking_app/controllers/buses_controller.dart';
import 'package:parking_app/controllers/loading_controller.dart';

class BusesSection extends StatelessWidget {
  BusesSection({
    super.key,
  });

  final _busesController = Get.find<BusesController>();
  final _loadingController = Get.find<LoadingController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 20.0,
              left: 15.0,
              right: 15.0,
              bottom: 0,
            ),
            child: TextFormField(
              initialValue: _busesController.searchText,
              onChanged: (value) {
                _busesController.searchText = value;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z0-9\s]'),
                ),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                hintText: 'Buscar micro...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: Scrollbar(
              interactive: true,
              thumbVisibility: true,
              thickness: 5.0,
              child: GridView(
                key: const PageStorageKey('buses'),
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 155,
                ),
                children: _busesController.filteredBuses
                    .map(
                      (bus) => Padding(
                        padding: const EdgeInsets.only(
                          left: 4.0,
                          right: 4.0,
                          bottom: 4.0,
                        ),
                        child: InkWell(
                          onTap: () async {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 5.0),
                                Text(
                                  bus.name.capitalize!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                CircleAvatar(
                                  backgroundColor: Colors.deepPurple,
                                  radius: 32,
                                  child: Text(
                                    bus.name.capitalize!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ), //Text
                                ),
                                const SizedBox(height: 15.0),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 65,
                                        height: 27,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13.0),
                                              side: const BorderSide(
                                                color: Colors.white,
                                                width: 1.5,
                                              ),
                                            ),
                                            backgroundColor:
                                                const Color.fromARGB(
                                              255,
                                              26,
                                              181,
                                              75,
                                            ),
                                            elevation: 5,
                                          ),
                                          onPressed: () async {
                                            _loadingController.isLoading = true;
                                            await _busesController.getBusRoute(
                                              bus.name,
                                              'IDA',
                                            );
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                            _loadingController.isLoading =
                                                false;
                                          },
                                          child: const Text(
                                            'Ida',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      SizedBox(
                                        width: 78.6,
                                        height: 27,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13.0),
                                              side: const BorderSide(
                                                color: Colors.white,
                                                width: 1.5,
                                              ),
                                            ),
                                            backgroundColor:
                                                const Color.fromARGB(
                                              255,
                                              230,
                                              50,
                                              37,
                                            ),
                                            elevation: 5,
                                          ),
                                          onPressed: () async {
                                            _loadingController.isLoading = true;
                                            await _busesController.getBusRoute(
                                              bus.name,
                                              'VUELTA',
                                            );
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                            _loadingController.isLoading =
                                                false;
                                          },
                                          child: const Text(
                                            'Vuelta',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
