import 'package:flutter_application/models/ApartmentId.dart';
import 'package:flutter_application/models/CompanyInfo.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'company_event.dart';
part 'company_state.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  CompanyBloc() : super(CompanyInitial()) {
    on<AppartamentsLoaded>((event, emit) async {
      try {
        var response = await DioSingleton()
            .dio
            .get('employee/apartments/apartment_info/${event.id}');
        ApartmentId apartmentId = ApartmentId.fromJson(response.data);

        if (state is CompanyStateData) {
          emit((state as CompanyStateData).copyWith(apartment: apartmentId));
        } else {
          emit(CompanyStateData(apartment: apartmentId));
        }
      } catch (e) {
        print('Ошибка при получении информации о квартире: $e');
      }
    });

    on<CompanyLoaded>((event, emit) async {
      try {
        var response = await DioSingleton().dio.get('get_profile_uk');
        CompanyInfo companyInfo = CompanyInfo.fromJson(response.data);

        if (state is CompanyStateData) {
          emit((state as CompanyStateData).copyWith(company: companyInfo));
        } else {
          emit(CompanyStateData(company: companyInfo));
        }
      } catch (e) {
        print('Ошибка при получении информации о компании: $e');
      }
    });
  }
}
