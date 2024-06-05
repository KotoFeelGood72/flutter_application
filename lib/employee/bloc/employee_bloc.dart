import 'package:dio/dio.dart';
import 'package:flutter_application/models/EmployeeInfo.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeInitial()) {
    on<EmployeeLoaded>((event, emit) async {
      print('EmployeeLoaded event received');
      emit(EmployeeLoading());
      try {
        var response = await DioSingleton().dio.get('employee_info');
        EmployeeInfo employee =
            EmployeeInfo.fromJson(response.data as Map<String, dynamic>);
        print('Employee data loaded: ${employee.firstname}');
        emit(EmployeeDataLoaded(employeeInfo: employee));
      } catch (e) {
        print('Error loading employee data: $e');
        emit(EmployeeError(message: 'Failed to load employee data.'));
      }
    });

    on<UploadEmployeePhoto>((event, emit) async {
      emit(EmployeeLoading());
      try {
        var response = await DioSingleton()
            .dio
            .post('employee_info/add_photo', data: event.formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var updatedResponse = await DioSingleton().dio.get('employee_info');
          EmployeeInfo updatedEmployee = EmployeeInfo.fromJson(
              updatedResponse.data as Map<String, dynamic>);
          emit(EmployeeDataLoaded(employeeInfo: updatedEmployee));
        } else {
          emit(EmployeeError(message: 'Failed to upload photo.'));
        }
      } catch (e) {
        emit(EmployeeError(message: 'Failed to upload photo.'));
      }
    });
  }
}
