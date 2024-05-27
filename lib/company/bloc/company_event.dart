part of 'company_bloc.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();
}

class CompanyLoaded extends CompanyEvent {
  // final CompanyInfo company;

  // const CompanyLoaded(this.company);

  @override
  List<Object> get props => [];
}

class AppartamentsLoaded extends CompanyEvent {
  final int id;

  const AppartamentsLoaded(this.id);

  @override
  List<Object> get props => [id];
}
