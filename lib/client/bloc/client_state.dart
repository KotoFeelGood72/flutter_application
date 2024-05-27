part of 'client_bloc.dart';

class ClientState extends Equatable {
  final List<Order>? orders;
  final ClientUser? userInfo;
  final ApartmentInfo? activeApartment;
  final List<ApartmentInfo>? apartments;

  ClientState(
      {this.orders, this.userInfo, this.activeApartment, this.apartments});

  @override
  List<Object?> get props => [orders, userInfo, activeApartment, apartments];

  ClientState copyWith({
    List<Order>? orders,
    ClientUser? userInfo,
    ApartmentInfo? activeApartment,
    List<ApartmentInfo>? apartments,
  }) {
    return ClientState(
      orders: orders ?? this.orders,
      userInfo: userInfo ?? this.userInfo,
      activeApartment: activeApartment ?? this.activeApartment,
      apartments: apartments ?? this.apartments,
    );
  }
}

class ApartmentInfo extends Equatable {
  final int id;
  final String name;

  ApartmentInfo({required this.id, required this.name});
  factory ApartmentInfo.fromJson(Map<String, dynamic> json) {
    return ApartmentInfo(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  @override
  List<Object?> get props => [id, name];
}

class ActiveApartmentState extends ClientState {
  final ApartmentInfo activeApartment;

  ActiveApartmentState({required this.activeApartment});

  @override
  List<Object?> get props => [activeApartment];
}
