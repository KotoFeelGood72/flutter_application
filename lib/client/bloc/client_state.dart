part of 'client_bloc.dart';

abstract class ClientState {}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientDataLoaded extends ClientState {
  ClientDataLoaded({required this.userInfo});
  final dynamic userInfo;
}
