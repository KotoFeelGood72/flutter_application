class Tenant {
  final int id;
  final String firstname;
  final String lastname;
  final String phoneNumber;
  final String email;
  final String photoPath;
  final double balance;

  Tenant({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    required this.email,
    required this.photoPath,
    required this.balance,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'] ?? 0,
      firstname: json['first_name'],
      lastname: json['last_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      photoPath: json['photo_path'],
      balance: json['balance'].toDouble(),
    );
  }
}

class TenantModels {
  final List<Tenant> tenants;

  TenantModels({required this.tenants});

  factory TenantModels.fromJson(List<dynamic> json) {
    return TenantModels(
      tenants: json.map((tenant) => Tenant.fromJson(tenant)).toList(),
    );
  }
}
