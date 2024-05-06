part of 'client_bloc.dart';

class ClientEvent {}

class ClientInfoLoad extends ClientEvent {}

class ClientInfoUser extends ClientEvent {}

class SetActiveApartmentEvent extends ClientEvent {
  final int id;
  final String name;

  SetActiveApartmentEvent({required this.id, required this.name});
}
