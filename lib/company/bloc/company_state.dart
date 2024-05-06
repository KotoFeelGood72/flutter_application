part of 'company_bloc.dart';

abstract class CompanyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CompanyInitial extends CompanyState {}

class CompanyDataLoaded extends CompanyState {}
