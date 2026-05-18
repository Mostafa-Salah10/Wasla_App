class ResidentTripModel {
  final String driverName;
  final String driverId;
  final int yearsOfExperience;
  final double rating;
  final String vehicleModel;
  final String vehicleNumber;
  final String vehicleImage;
  final String vehicleColor;
  final String? driverPhone;
  final String driverImage;
  final String pickUpPlace;
  final String dropOffPlace;
  final DateTime startRide;
  final DateTime endRide;
  final double price;
  final double pickUpLatitude;
  final double pickUpLongitude;

  ResidentTripModel({
    required this.pickUpLatitude,
    required this.pickUpLongitude,
    required this.driverName,
    required this.driverId,
    required this.yearsOfExperience,
    required this.rating,
    required this.vehicleModel,
    required this.vehicleNumber,
    required this.vehicleImage,
    required this.vehicleColor,
    required this.driverPhone,
    required this.driverImage,
    required this.pickUpPlace,
    required this.dropOffPlace,
    required this.startRide,
    required this.endRide,
    required this.price,
  });

  factory ResidentTripModel.fromJson(Map<String, dynamic> json) {
    return ResidentTripModel(
      driverName: json['driverName'],
      driverId: json['driverID'],
      yearsOfExperience: json['yearsOfExperience'],
      rating: (json['rating'] as num).toDouble(),
      vehicleModel: json['vehicleModel'],
      vehicleNumber: json['vehicleNumber'],
      vehicleImage: json['vehicleImage'],
      vehicleColor: json['vehicleColor'],
      driverPhone: json['driverPhone'],
      driverImage: json['driverImage'],
      pickUpPlace: json['pickUpPlace'],
      dropOffPlace: json['dropOffPlace'],
      startRide: DateTime.parse(json['startRide']),
      endRide: DateTime.parse(json['endRide']),
      price: (json['price'] as num).toDouble(),
      pickUpLatitude:(json['pickUpLatitude'] as num).toDouble() ,
      pickUpLongitude: (json['pickUpLongitude'] as num).toDouble(),
    );
  }
}
