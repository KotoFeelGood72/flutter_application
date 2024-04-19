part of 'client_bloc.dart';

class ClientEvent {}

class ClientInfoLoad extends ClientEvent {
  Future<void> _getUserInfo() async {
    try {
      final response = await DioSingleton().dio.get('client/profile');
    } catch (e) {}
  }
}
