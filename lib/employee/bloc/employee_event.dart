part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

class EmployeeLoaded extends EmployeeEvent {}

class UploadEmployeePhoto extends EmployeeEvent {
  final FormData formData;

  const UploadEmployeePhoto(this.formData);

  @override
  List<Object?> get props => [formData];
}
