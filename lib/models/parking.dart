import 'dart:convert';

List<Parking> parkingsFromJson(String str) =>
    List<Parking>.from(json.decode(str).map((x) => Parking.fromJson(x)));
List<Parking> parkingsFromJsonList(List<dynamic> data) =>
    List<Parking>.from(data.map((x) => Parking.fromJson(x)));
Parking parkingFromJson(String str) => Parking.fromJson(json.decode(str));

String parkingsToJson(List<Parking> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
String parkingToJson(Parking data) => json.encode(data.toJson());

class Parking {
  int id;
  Geom geom;
  bool isFull;
  String? startAttention;
  String? endAttention;
  String? imageUrl;
  DateTime createdAt;
  DateTime updatedAt;

  Parking({
    required this.id,
    required this.geom,
    required this.isFull,
    this.startAttention,
    this.endAttention,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Parking.fromJson(Map<String, dynamic> json) => Parking(
        id: json["id"],
        geom: Geom.fromJson(json["geom"]),
        isFull: json["isFull"],
        startAttention: json["startAttention"],
        endAttention: json["endAttention"],
        imageUrl: json["imageUrl"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "geom": geom.toJson(),
        "isFull": isFull,
        "startAttention": startAttention,
        "endAttention": endAttention,
        "imageUrl": imageUrl,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };

  @override
  String toString() {
    return 'Parking{id: $id, geom: $geom, isFull: $isFull, startAttention: $startAttention, endAttention: $endAttention, imageUrl: $imageUrl, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

class Geom {
  String type;
  List<double> coordinates;

  Geom({
    required this.type,
    required this.coordinates,
  });

  factory Geom.fromJson(Map<String, dynamic> json) => Geom(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };

  @override
  String toString() {
    return 'Geom{type: $type, coordinates: $coordinates}';
  }
}
