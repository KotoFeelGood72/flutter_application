part of 'employee_bloc.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeDataLoaded extends EmployeeState {
  final EmployeeInfo employeeInfo;

  const EmployeeDataLoaded({required this.employeeInfo});

  @override
  List<Object?> get props => [employeeInfo];
}
