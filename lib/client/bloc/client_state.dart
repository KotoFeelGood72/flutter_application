part of 'client_bloc.dart';

abstract class ClientState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClientInitial extends ClientState {}

class ClientDataLoaded extends ClientState {
  final List<Order> orders;

  ClientDataLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}

class ClientInfoUsers extends ClientState {
  final Map<String, dynamic> userInfo;

  ClientInfoUsers({required this.userInfo});

  @override
  List<Object?> get props => [userInfo];
}

// Класс для хранения информации об апартаменте
class ApartmentInfo extends Equatable {
  final int id;
  final String name;

  ApartmentInfo({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class ActiveApartmentState extends ClientState {
  final ApartmentInfo activeApartment;

  ActiveApartmentState({required this.activeApartment});

  @override
  List<Object?> get props => [activeApartment];
}
