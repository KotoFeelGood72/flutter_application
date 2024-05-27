import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application/client/bloc/client_bloc.dart';

class SelectObjects extends StatefulWidget {
  const SelectObjects({super.key});

  @override
  State<SelectObjects> createState() => _SelectObjectsState();
}

class _SelectObjectsState extends State<SelectObjects> {
  late ClientBloc _clientBloc;
  ApartmentInfo? _selectedApartment;

  @override
  void initState() {
    super.initState();
    _clientBloc = BlocProvider.of<ClientBloc>(context);
    _clientBloc.add(ClientInfoUser());

    final currentState = _clientBloc.state;
    if (currentState.activeApartment != null) {
      _selectedApartment = currentState.activeApartment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const ModalHeader(title: 'Select an object'),
            const SizedBox(height: 20),
            Expanded(
              child: BlocListener<ClientBloc, ClientState>(
                listener: (context, state) {
                  if (state.userInfo != null &&
                      state.userInfo!.apartmentInfo != null) {
                    List<ApartmentInfo> apartments =
                        state.userInfo!.apartmentInfo ?? [];
                    if (_selectedApartment == null && apartments.isNotEmpty) {
                      setState(() {
                        _selectedApartment = apartments.first;
                      });
                    }
                  }
                },
                child: BlocBuilder<ClientBloc, ClientState>(
                  builder: (context, state) {
                    if (state is ClientState &&
                        state.userInfo != null &&
                        state.userInfo!.apartmentInfo != null) {
                      List<ApartmentInfo> apartments =
                          state.userInfo!.apartmentInfo ?? [];

                      // var apartments = (state.userInfo!.apartmentInfo as List)
                      //     .map((e) =>
                      //         ApartmentInfo.fromJson(e as Map<String, dynamic>))
                      //     .toList();

                      return ListView.builder(
                        itemCount: apartments.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                                bottom:
                                    index == apartments.length - 1 ? 0 : 15),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: index == apartments.length - 1
                                      ? Colors.transparent
                                      : const Color.fromARGB(69, 158, 158, 158),
                                  width: 1,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.only(bottom: 15),
                            child: InkWell(
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  _selectedApartment = apartments[index];
                                });
                                _clientBloc.add(SetActiveApartmentEvent(
                                    id: apartments[index].id,
                                    name: apartments[index].name));
                              },
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 20),
                                    child: SquareRadio<ApartmentInfo>(
                                      value: apartments[index],
                                      groupValue: _selectedApartment,
                                      onChanged: (ApartmentInfo? value) {
                                        if (value != null) {
                                          setState(() {
                                            _selectedApartment = value;
                                          });
                                          _clientBloc.add(
                                              SetActiveApartmentEvent(
                                                  id: value.id,
                                                  name: value.name));
                                        }
                                      },
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  ObjectTile(
                                    title: apartments[index].name,
                                    subtitle: 'ID: ${apartments[index].id}',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
            if (_selectedApartment != null)
              Text('Selected Apartment: ${_selectedApartment!.name}')
            else
              const Text('No Apartment Selected')
          ],
        ),
      ),
    );
  }
}

class ObjectTile extends StatelessWidget {
  const ObjectTile({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(subtitle,
            style: const TextStyle(color: Color(0xFF878E92), fontSize: 14)),
      ],
    );
  }
}

class SquareRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final Color activeColor;

  const SquareRadio({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.activeColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: value == groupValue ? activeColor : Colors.transparent,
          border: Border.all(
            color: value == groupValue
                ? activeColor
                : const Color.fromARGB(110, 158, 158, 158),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: value == groupValue
            ? Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      ),
    );
  }
}
