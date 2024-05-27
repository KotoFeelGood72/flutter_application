import 'package:flutter_application/models/Appartments.dart';

class ApartmentId {
  final int id;
  final String? apartmentName;
  final double? area;
  final bool? garden;
  final bool? pool;
  final String? photoPath;
  final String? internetOperator;
  final String? internetSpeed;
  final String? internetFee;
  final String? keyHolder;
  final List<Bathroom>? bathrooms;
  final int? activeOrderCount;

  ApartmentId({
    required this.id,
    this.apartmentName,
    this.area,
    this.garden,
    this.pool,
    this.photoPath,
    this.internetOperator,
    this.internetSpeed,
    this.internetFee,
    this.keyHolder,
    this.bathrooms,
    this.activeOrderCount,
  });

  ApartmentId copyWith({
    int? id,
    String? apartmentName,
    double? area,
    bool? garden,
    bool? pool,
    String? photoPath,
    String? internetOperator,
    String? internetSpeed,
    String? internetFee,
    String? keyHolder,
    List<Bathroom>? bathrooms,
    int? activeOrderCount,
  }) {
    return ApartmentId(
      id: id ?? this.id,
      apartmentName: apartmentName ?? this.apartmentName,
      area: area ?? this.area,
      garden: garden ?? this.garden,
      pool: pool ?? this.pool,
      photoPath: photoPath ?? this.photoPath,
      internetOperator: internetOperator ?? this.internetOperator,
      internetSpeed: internetSpeed ?? this.internetSpeed,
      internetFee: internetFee ?? this.internetFee,
      keyHolder: keyHolder ?? this.keyHolder,
      bathrooms: bathrooms ?? this.bathrooms,
      activeOrderCount: activeOrderCount ?? this.activeOrderCount,
    );
  }

  factory ApartmentId.fromJson(Map<String, dynamic> json) {
    var bathroomsJson = json['bathrooms'] as List<dynamic>?;
    List<Bathroom> bathroomsList = bathroomsJson != null
        ? bathroomsJson
            .map((bathroomJson) => Bathroom.fromJson(bathroomJson))
            .toList()
        : [];

    return ApartmentId(
      id: json['id'] ?? 0,
      apartmentName: json['apartment_name'] as String?,
      area: (json['area'] != null) ? (json['area'] as num).toDouble() : null,
      garden: json['garden'] as bool?,
      pool: json['pool'] as bool?,
      photoPath: json['photo_path'] as String?,
      internetOperator: json['internet_operator'] as String?,
      internetSpeed: json['internet_speed'] as String?,
      internetFee: json['internet_fee']?.toString(),
      keyHolder: json['key_holder'] as String?,
      bathrooms: bathroomsList,
      activeOrderCount: json['active_order_count'] as int?,
    );
  }
}
