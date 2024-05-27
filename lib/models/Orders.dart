import 'dart:convert';

// Модель для AdditionalInfo
class AdditionalInfo {
  final List<dynamic> additionalServiceList;

  AdditionalInfo({required this.additionalServiceList});

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalInfo(
      additionalServiceList: json['additional_service_list'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'additional_service_list': additionalServiceList,
    };
  }
}

// Модель для Executor
class Executor {
  final String firstname;
  final String lastname;
  final String phoneNumber;
  final String email;
  final String specialization;
  final String role;
  final int id;

  Executor({
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    required this.email,
    required this.specialization,
    required this.role,
    required this.id,
  });

  factory Executor.fromJson(Map<String, dynamic> json) {
    return Executor(
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      specialization: json['specialization'] ?? '',
      role: json['role'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'phone_number': phoneNumber,
      'email': email,
      'specialization': specialization,
      'role': role,
      'id': id,
    };
  }
}

// Модель для Order
class SingleOrder {
  final int id;
  final String iconPath;
  final String appartamentName;
  final String serviceName;
  final String createdAt;
  final String completionDate;
  final String completedAt;
  final String status;
  final AdditionalInfo additionalInfo;
  final Executor executor;

  SingleOrder({
    required this.appartamentName,
    required this.id,
    required this.iconPath,
    required this.serviceName,
    required this.createdAt,
    required this.completionDate,
    required this.completedAt,
    required this.status,
    required this.additionalInfo,
    required this.executor,
  });

  factory SingleOrder.fromJson(Map<String, dynamic> json) {
    return SingleOrder(
      id: json['id'] ?? 0,
      appartamentName: json['apartment_name'] ?? '',
      iconPath: json['icon_path'] ?? '',
      serviceName: json['service_name'] ?? '',
      createdAt: json['created_at'] ?? '',
      completionDate: json['completion_date'] ?? '',
      completedAt: json['completed_at'] ?? '',
      status: json['status'] ?? '',
      additionalInfo: AdditionalInfo.fromJson(json['additional_info'] ?? {}),
      executor: Executor.fromJson(json['executor'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon_path': iconPath,
      'service_name': serviceName,
      'apartment_name': appartamentName,
      'created_at': createdAt,
      'completion_date': completionDate,
      'completed_at': completedAt,
      'status': status,
      'additional_info': additionalInfo.toJson(),
      'executor': executor.toJson(),
    };
  }
}
