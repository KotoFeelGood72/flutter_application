import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application/client/bloc/client_bloc.dart';

class ApartmentInfo {
  final int id;
  final String name;

  ApartmentInfo({required this.id, required this.name});

  factory ApartmentInfo.fromJson(Map<String, dynamic> json) {
    return ApartmentInfo(
      id: json['id'],
      name: json['name'],
    );
  }
}

class SelectObjects extends StatefulWidget {
  @override
  State<SelectObjects> createState() => _SelectObjectsState();
}

class _SelectObjectsState extends State<SelectObjects> {
  late ClientBloc _clientBloc;
  ApartmentInfo? _selectedApartment; // Для хранения выбранной квартиры

  @override
  void initState() {
    super.initState();
    _clientBloc = BlocProvider.of<ClientBloc>(context, listen: false);
    _clientBloc.add(
        ClientInfoUser()); // Запускаем событие загрузки данных пользователя
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select an object',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<ClientBloc, ClientState>(
                builder: (context, state) {
                  if (state is ClientInfoUsers) {
                    var apartments = (state.userInfo['apartment_info'] as List)
                        .map((e) => ApartmentInfo.fromJson(e))
                        .toList();

                    return ListView(
                      children: apartments.map((apartment) {
                        return ListTile(
                          title: ObjectTile(
                              title: apartment.name,
                              subtitle: 'ID: ${apartment.id}'),
                          leading: Radio<ApartmentInfo>(
                            value: apartment,
                            groupValue: _selectedApartment,
                            onChanged: (ApartmentInfo? value) {
                              setState(() {
                                _selectedApartment = value;
                              });
                              // Отправляем событие в Bloc при выборе квартиры
                              _clientBloc.add(SetActiveApartmentEvent(
                                  id: value!.id, name: value.name));
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ObjectTile extends StatelessWidget {
  const ObjectTile({super.key, required this.title, required this.subtitle});
  // Props
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
