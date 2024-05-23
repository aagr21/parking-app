import 'dart:convert';

List<Bus> busesFromJson(String str) =>
    List<Bus>.from(json.decode(str).map((x) => Bus.fromJson(x)));
String busesToJson(List<Bus> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bus {
  int id;
  String name;

  Bus({
    required this.id,
    required this.name,
  });

  factory Bus.fromJson(Map<String, dynamic> json) => Bus(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

BusRoute busRouteFromJson(String str) => BusRoute.fromJson(json.decode(str));

String busRouteToJson(BusRoute data) => json.encode(data.toJson());

class BusRoute extends Bus {
  Geom geom;
  String ground;
  String direction;

  BusRoute({
    required this.geom,
    required this.ground,
    required this.direction,
    required super.id,
    required super.name,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) => BusRoute(
        id: json["id"],
        geom: Geom.fromJson(json["geom"]),
        name: json["name"],
        ground: json["ground"],
        direction: json["direction"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "geom": geom.toJson(),
        "name": name,
        "ground": ground,
        "direction": direction,
      };
}

class Geom {
  String type;
  List<List<double>> coordinates;

  Geom({
    required this.type,
    required this.coordinates,
  });

  factory Geom.fromJson(Map<String, dynamic> json) => Geom(
        type: json["type"],
        coordinates: List<List<double>>.from(json["coordinates"]
            .map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(
            coordinates.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}
