import 'package:flutter_application/client/pages/inquires/components/inq_services.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'client_event.dart';
part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  ClientBloc() : super(ClientInitial()) {
    on<ClientInfoLoad>((event, emit) async {
      try {
        var response = await DioSingleton().dio.get('client/get_orders');
        List<Order> orders = (response.data['orders'] as List)
            .map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList();
        emit(ClientDataLoaded(orders: orders));
        print('${orders.length}, orders');
      } catch (e) {
        print('Ошибка при получении заказов: $e');
      }
    });
    on<ClientInfoUser>((event, emit) async {
      try {
        var response = await DioSingleton().dio.get('client/profile');
        Map<String, dynamic> userInfo = response.data;
        emit(ClientInfoUsers(userInfo: userInfo));
      } catch (e) {
        print('Ошибка при получении информации о пользователе: $e');
      }
    });

    on<SetActiveApartmentEvent>((event, emit) {
      var apartmentInfo = ApartmentInfo(id: event.id, name: event.name);
      emit(ActiveApartmentState(activeApartment: apartmentInfo));
    });
  }
}
