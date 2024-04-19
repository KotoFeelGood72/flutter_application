import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'client_event.dart';
part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  ClientBloc() : super(ClientInitial()) {
    on<ClientInfoLoad>((event, emit) async {
      final clientInfo = await DioSingleton().dio.get('client/profile');
      emit(ClientDataLoaded(userInfo: clientInfo));
      print('${clientInfo} userInfo');
    });
  }
}
