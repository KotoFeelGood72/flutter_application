import 'package:flutter_application/client/pages/inquires/components/inq_services.dart';
import 'package:flutter_application/models/ClientUser.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'client_event.dart';
part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  ClientBloc() : super(ClientState()) {
    on<ClientInfoLoad>((event, emit) async {
      try {
        var response = await DioSingleton().dio.get('client/get_orders');
        List<Order> orders = (response.data as List)
            .map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList();
        emit(state.copyWith(orders: orders));
      } catch (e) {
        // print('Ошибка при получении заказов: $e');
      }
    });

    on<ClientInfoUser>((event, emit) async {
      try {
        var response = await DioSingleton().dio.get('client/profile');
        if (response.data != null) {
          ClientUser userInfo = ClientUser.fromJson(response.data);
          List<ApartmentInfo> apartments = userInfo.apartmentInfo ?? [];

          print(userInfo);

          ApartmentInfo? newActiveApartment = state.activeApartment;
          if (newActiveApartment == null && apartments.isNotEmpty) {
            newActiveApartment = apartments.first;
          }

          emit(state.copyWith(
              userInfo: userInfo,
              apartments: apartments,
              activeApartment: newActiveApartment));
        }
      } catch (e) {
        // print('Ошибка при получении информации о пользователе: $e');
      }
    });

    on<SetActiveApartmentEvent>((event, emit) {
      var apartmentInfo = ApartmentInfo(id: event.id, name: event.name);
      emit(state.copyWith(activeApartment: apartmentInfo));
    });
  }
}
