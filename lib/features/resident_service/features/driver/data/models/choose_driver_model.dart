class ChooseDriverModel {
  final String id;
  final String name;
  final String photo;
  final int rate;
  final double price;

  ChooseDriverModel({
    required this.id,
    required this.name,
    required this.photo,
    required this.rate,
    required this.price,
  });

  factory ChooseDriverModel.fromJson(Map<String, dynamic> json) {
    return ChooseDriverModel(
      id: json['id'] ?? '',
      name: json['name'] ?? "",
      photo: json['photo'] ?? "",
      rate: json['rate'] ?? 0,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'rate': rate,
      'price': price,
    };
  }
}
