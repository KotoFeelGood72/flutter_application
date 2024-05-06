part of 'contacts_bloc.dart';

sealed class ContactsState extends Equatable {
  const ContactsState();
  
  @override
  List<Object> get props => [];
}

final class ContactsInitial extends ContactsState {}
