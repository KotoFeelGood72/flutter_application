class EmployeeInfo {
  EmployeeInfo({
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    required this.photoPath,
    required this.objectName,
  });

  final String firstname;
  final String lastname;
  final String phoneNumber;
  final String photoPath;
  final String objectName;

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeInfo(
      firstname: json['first_name'],
      lastname: json['last_name'],
      phoneNumber: json['phone_number'],
      photoPath: json['photo_path'],
      objectName: json['object_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstname,
      'last_name': lastname,
      'phone_number': phoneNumber,
      'photo_path': photoPath,
      'object_name': objectName,
    };
  }
}
