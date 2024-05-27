class Appartaments {
  final int id;
  final String name;

  Appartaments({required this.id, required this.name});

  factory Appartaments.fromJson(Map<String, dynamic> json) {
    return Appartaments(
        id: json['id'] as int, name: json['apartment_name'] as String);
  }
}

class Bathroom {
  final int id;
  final String characteristic;

  Bathroom({
    required this.id,
    required this.characteristic,
  });

  factory Bathroom.fromJson(Map<String, dynamic> json) {
    return Bathroom(
      id: json['id'],
      characteristic: json['characteristic'],
    );
  }
}
