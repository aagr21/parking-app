import 'package:http/http.dart' as http;

import 'package:parking_app/models/bus.dart';

class BusesServices {
  static const String baseUrl = 'https://paradas-api-v2.adaptable.app/api';

  static Future<List<Bus>?> getBuses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/lines-names'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return busesFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<BusRoute?> getBusRoute(String name, String ground) async {
    final response = await http.post(
      Uri.parse('$baseUrl/lines-routes/find-line-route'),
      body: {
        'name': name,
        'ground': ground,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return busRouteFromJson(response.body);
    } else {
      return null;
    }
  }
}
