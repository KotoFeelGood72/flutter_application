part of 'company_bloc.dart';

abstract class CompanyState extends Equatable {
  const CompanyState();

  @override
  List<Object?> get props => [];
}

class CompanyInitial extends CompanyState {}

class ApartmentsLoad extends CompanyState {
  final ApartmentId apartment;

  const ApartmentsLoad(this.apartment);

  @override
  List<Object?> get props => [apartment];
}

class CompanyStateData extends CompanyState {
  final ApartmentId? apartment;
  final CompanyInfo? company;

  const CompanyStateData({
    this.apartment,
    this.company,
  });

  CompanyStateData copyWith({
    ApartmentId? apartment,
    CompanyInfo? company,
  }) {
    return CompanyStateData(
      apartment: apartment ?? this.apartment,
      company: company ?? this.company,
    );
  }

  @override
  List<Object?> get props => [apartment, company];
}
