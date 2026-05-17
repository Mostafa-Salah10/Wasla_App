class PlaceModel {
  String name;
  String country;
  double lat;
  double lng;

  PlaceModel({
    required this.name,
    required this.country,
    required this.lat,
    required this.lng,
  });

  factory PlaceModel.fromGeoapify(Map<String, dynamic> json) {
  final props = json['properties'];

  return PlaceModel(
    name: props['formatted'] ?? '',
    country: props['country'] ?? '',
    lat: props['lat'] ?? 0.0,
    lng: props['lon'] ?? 0.0,
  );
}
}