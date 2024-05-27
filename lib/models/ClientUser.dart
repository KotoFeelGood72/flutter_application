import 'package:flutter_application/client/bloc/client_bloc.dart';

class ClientUser {
  final String firstname;
  final String lastname;
  final String phoneNumber;
  final String email;
  final String role;
  final List<ApartmentInfo> apartmentInfo;
  final String photoPath;
  final double balance;

  ClientUser({
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    required this.email,
    required this.role,
    required this.apartmentInfo,
    required this.photoPath,
    required this.balance,
  });

  factory ClientUser.fromJson(Map<String, dynamic> json) {
    var apartments = (json['apartment_info'] as List)
        .map((e) => ApartmentInfo.fromJson(e as Map<String, dynamic>))
        .toList();
    return ClientUser(
      firstname: json['first_name'],
      lastname: json['last_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      role: json['role'],
      apartmentInfo: apartments,
      photoPath: json['photo_path'],
      balance: json['balance'].toDouble(),
    );
  }
}
