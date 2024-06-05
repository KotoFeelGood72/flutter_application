class EmployeeInfo {
  EmployeeInfo({
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    required this.photoPath,
    required this.objectName,
    required this.email,
  });

  final String firstname;
  final String email;
  final String lastname;
  final String phoneNumber;
  final String photoPath;
  final String objectName;

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeInfo(
      firstname: json['first_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      lastname: json['last_name'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      photoPath: json['photo_path'] as String? ?? '',
      objectName: json['object_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstname,
      'last_name': lastname,
      'phone_number': phoneNumber,
      'photo_path': photoPath,
      'object_name': objectName,
      'email': email,
    };
  }
}
