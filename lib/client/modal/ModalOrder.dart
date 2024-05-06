import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application/client/bloc/client_bloc.dart';
import 'package:flutter_application/client/modal/components/select_objects.dart';
import 'package:flutter_application/client/modal/components/serviceItem.dart';
// import 'package:flutter_application/client/modal/components/service_content_builder.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/ModalInfo/payment/info_paid_modal.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedService {
  final int id;
  final String serviceName;
  final double price;
  int quantity;

  SelectedService(
    this.id, {
    required this.serviceName,
    required this.price,
    required this.quantity,
  });
}

class ModalOrder extends StatefulWidget {
  final int id;
  const ModalOrder({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ModalOrder> createState() => _ModalOrderState();
}

class _ModalOrderState extends State<ModalOrder> {
  @override
  void initState() {
    super.initState();
    _getOrdersList();
  }

  Map<String, dynamic> servicesAll = {};

  final Map<String, Color> serviceColors = {
    'Cleaning': const Color(0xFFECA564),
    'Gardener': const Color(0xFF61BE75),
    'Pool': const Color(0xFF61B3BE),
    'Trash removal': const Color(0xFFB7BE61),
    'Other': const Color(0xFF7961BE),
  };

  String? _selectedService = 'Cleaning';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<SelectedService> selectedServices = [];

  Future<void> _getOrdersList() async {
    try {
      final response = await DioSingleton().dio.get('client/get_order_list');
      setState(() {
        servicesAll = response.data;
        print(servicesAll);
      });
    } catch (e) {
      // print("Ошибка при получении информации о заказе: $e");
    }
  }

  Future<void> submitOrder() async {
    final String completionDate = "${selectedDate.toLocal()}".split(' ')[0];
    final String completionTime = selectedTime.format(context);
    List<Map<String, dynamic>> additionalServicesData =
        selectedServices.map((service) {
      return {
        'additional_service_id': service.id,
        "quantity": service.quantity,
      };
    }).toList();

    final Map<String, dynamic> orderData = {
      "apartment_id": widget.id,
      "completion_date": completionDate,
      "completion_time": completionTime,
      "selected_services": _selectedService,
      "notes": "string",
      "additional_services": additionalServicesData,
      "documents": _selectedFiles.map((file) {
        return {
          "file_name": file.name,
          "mime_type": file.extension,
        };
      }).toList(),
    };
    final _clientsBloc = BlocProvider.of<ClientBloc>(context);
    try {
      final response =
          await DioSingleton().dio.post('client/create_order', data: orderData);
      _clientsBloc.add(ClientInfoLoad());
      Navigator.pop(context, true);

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 100,
            color: Colors.green,
            child: const Center(
              child: Text(
                'Your order has been successfully created',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Error submitting order: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _onServiceSelected(String? service) {
    if (service != null) {
      setState(() {
        _selectedService = service;
      });
    }
  }

  List<PlatformFile> _selectedFiles = [];

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _selectedFiles = result.files;
        print(_selectedFiles);
      });
    } else {}
  }

  void updateSelectedServices(
      bool isSelected, int id, String serviceName, double price, int quantity) {
    setState(() {
      final index = selectedServices.indexWhere((service) => service.id == id);
      if (isSelected) {
        if (index == -1) {
          selectedServices.add(SelectedService(
            id,
            serviceName: serviceName,
            price: price,
            quantity: quantity,
          ));
        } else {
          selectedServices[index].quantity = quantity;
        }
      } else {
        if (index != -1) {
          selectedServices.removeAt(index);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredServices = [];
    if (servicesAll != null && servicesAll['additional_services'] != null) {
      filteredServices =
          servicesAll['additional_services'][_selectedService] ?? [];
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(17.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 10),
          ModalHeader(title: 'Service'),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SelectObjects();
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 1),
              margin: const EdgeInsets.only(bottom: 25),
              child: SizedBox(
                height: 66,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: const Text(
                        'Smart, 17 12-2 floor 23',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Transform.rotate(
                      angle: math.pi / 2 * 3,
                      child: const Icon(
                        Icons.chevron_left,
                        color: Color(0xFF878E92),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              'Desired completion date:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 25),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      fillColor: const Color(0xFFF5F5F5),
                      filled: true,
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF878E92),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                        text: "${selectedDate.toLocal()}".split(' ')[0]),
                    onTap: () => _selectDate(context),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      fillColor: const Color(0xFFF5F5F5),
                      filled: true,
                      suffixIcon: const Icon(
                        Icons.access_time,
                        color: Color(0xFF878E92),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                        text: selectedTime.format(context)),
                    onTap: () => _selectTime(context),
                  ),
                ),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 23),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    child: Text(
                      'Types of services:',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: servicesAll['types_of_services']
                            ?.map<Widget>((service) {
                          bool isSelected = _selectedService == service['name'];
                          return ChoiceChip(
                            label: Text(service['name']),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              _onServiceSelected(
                                  selected ? service['name'] : null);
                            },
                            backgroundColor: serviceColors[service['name']],
                            selectedColor: serviceColors[service['name']],
                            padding: const EdgeInsets.all(9.0),
                            showCheckmark: false,
                            shape: isSelected
                                ? RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(14),
                                  )
                                : RoundedRectangleBorder(
                                    side: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                          );
                        }).toList() ??
                        [],
                  )
                ],
              )),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: filteredServices.map<Widget>((service) {
                return ServiceItem(
                    serviceName: service['name'].toString(),
                    price: service['price'],
                    onSelected: (bool isChecked, String name, double price,
                        int quantity) {
                      updateSelectedServices(
                          isChecked, service['id'], name, price, quantity);
                    },
                    isCountable: true);
              }).toList(),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(bottom: 10),
            child: TextButton.icon(
              icon: Transform.rotate(
                angle: math.pi / 5,
                child: const Icon(Icons.attach_file, color: Color(0xFF6873D1)),
              ),
              label: const Text(
                'Attach document',
                style: TextStyle(
                    color: Color(0xFF6873D1), fontWeight: FontWeight.w400),
              ),
              onPressed: () {
                pickFile();
              },
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
          ),
          Container(
            child: CustomBigBtn(
                title: 'Send',
                borderColor: Colors.white,
                titleColor: Colors.white,
                backgroundColor: Color(0xFF878E92),
                onTap: submitOrder,
                width: double.infinity),
          ),
        ],
      ),
    );
  }
}
