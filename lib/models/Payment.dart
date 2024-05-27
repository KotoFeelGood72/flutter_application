class Payments {
  final int id;
  final String apartmentName;
  final String createdAt;
  final String iconPath;
  final String status;

  Payments({
    required this.id,
    required this.apartmentName,
    required this.createdAt,
    required this.iconPath,
    required this.status,
  });

  factory Payments.fromJson(Map<String, dynamic> json) {
    return Payments(
      id: json['id'] as int,
      apartmentName: json['apartment_name'] as String,
      createdAt: json['created_at'] as String,
      iconPath: json['icon_path'] as String,
      status: json['status'] as String,
    );
  }
}

class Day {
  final String name;
  final List<Payments> services;

  Day({
    required this.name,
    required this.services,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    var serviceList = json['services'] as List;
    List<Payments> services = serviceList
        .map((serviceJson) =>
            Payments.fromJson(serviceJson as Map<String, dynamic>))
        .toList();
    return Day(
      name: json['name'] as String,
      services: services,
    );
  }
}

class DayList {
  final List<Day> days;

  DayList({required this.days});

  factory DayList.fromJson(List<dynamic> jsonList) {
    List<Day> days = jsonList
        .map((json) => Day.fromJson(json as Map<String, dynamic>))
        .toList();
    return DayList(days: days);
  }
}

class SinglePayment {
  final int id;
  final String name;
  final String img;
  final String serviceName;
  final double amount;

  SinglePayment(
      {required this.id,
      required this.name,
      required this.img,
      required this.serviceName,
      required this.amount});

  factory SinglePayment.fromJson(Map<String, dynamic> json) {
    return SinglePayment(
        id: json['id'] as int,
        name: json['apartment_name'] as String,
        img: json['icon_path'] as String,
        serviceName: json['service_name'] as String,
        amount: json['amount'] as double);
  }
}
