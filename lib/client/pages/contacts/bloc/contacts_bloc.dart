import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc() : super(ContactsInitial()) {
    on<ContactsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
