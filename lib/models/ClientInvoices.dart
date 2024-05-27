class ClientInvoices {
  final int id;
  final String name;
  final double amount;
  final String iconPath;

  ClientInvoices({
    required this.id,
    required this.name,
    required this.amount,
    required this.iconPath,
  });

  factory ClientInvoices.fromJson(Map<String, dynamic> json) {
    return ClientInvoices(
      id: json['id'] as int,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      iconPath: json['icon_path'] as String,
    );
  }
}
