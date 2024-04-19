import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/components/uk_dropdown.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/service/dio_config.dart';

class AddIssueInvoice extends StatefulWidget {
  final int id;
  const AddIssueInvoice({super.key, required this.id});

  @override
  State<AddIssueInvoice> createState() => _AddIssueInvoiceState();
}

class _AddIssueInvoiceState extends State<AddIssueInvoice> {
  List<Map<String, dynamic>> apartmentsList = [];
  final List<Map<String, dynamic>> servicesList = [
    {'name': 'Cleaning', 'id': '1'},
    {'name': 'Trash removal', 'id': '2'},
    {'name': 'Gardener', 'id': '3'},
    {'name': 'Pool', 'id': '4'},
    {'name': 'Electrician', 'id': '5'},
    {'name': 'Other', 'id': '6'},
    {'name': 'Electricity', 'id': '7'},
    {'name': 'Water', 'id': '8'},
    {'name': 'Internet', 'id': '9'},
    {'name': 'Rent', 'id': '10'},
  ];
  String selectedAppartamentId = '';
  String? selectedServiceId;
  String billNumber = '';
  String amount = '';
  String comment = '';

  final TextEditingController billNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAppartamentsList().then((_) {
      if (apartmentsList.isNotEmpty) {
        setState(() {
          selectedAppartamentId = apartmentsList[0]['id'].toString();
        });
      }
    });

    if (servicesList.isNotEmpty) {
      selectedServiceId = servicesList[0]['id'].toString();
    }
  }

  @override
  void dispose() {
    billNumberController.dispose();
    amountController.dispose();
    commentController.dispose();
    super.dispose();
  }

  void _onAppartamentSelected(String id) {
    setState(() {
      selectedAppartamentId = id;
    });
  }

  Future<void> _getAppartamentsList() async {
    try {
      final response = await DioSingleton()
          .dio
          .get('get_objects_uk/${widget.id}/apartment_list');
      if (response.data != null && response.data['apartments'] is List) {
        final List appartaments = response.data['apartments'];
        setState(() {
          apartmentsList = List<Map<String, dynamic>>.from(appartaments);
        });
      }
      print(response);
    } catch (e) {
      print("Ошибка при получении данных: $e");
    }
  }

  Future<void> fetchInvoice() async {
    final data = {
      "apartment_id": int.parse(selectedAppartamentId),
      "service_name": servicesList
          .firstWhere((service) => service['id'] == selectedServiceId)['name'],
      "service_id": int.parse(selectedServiceId!),
      "bill_number": billNumberController.text,
      "amount": amountController.text,
      "comment": commentController.text,
    };

    try {
      final response = await DioSingleton().dio.post(
            'employee/apartments/apartment_info/${widget.id}/invoice',
            data: data,
          );
      Navigator.pop(context);
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SuccessModal(message: "Invoice has been successfully issued.");
        },
      );
    } catch (e) {
      print("Ошибка при отправке данных: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(top: 18, left: 15, right: 15, bottom: 34),
      child: ListView(
        children: [
          ModalHeader(title: 'Issue an invoice'),
          UkDropdown(
            itemsList: apartmentsList,
            selectedItemKey: "1",
            onSelected: (selectedId) {},
            displayValueKey: "apartment_name",
            valueKey: "id",
          ),
          IssueInvoiceList(servicesList: servicesList),
          const SizedBox(height: 10),
          UkTextField(
            hint: 'Bill number',
            controller: billNumberController,
          ),
          const SizedBox(height: 10),
          UkTextField(hint: 'The amount', controller: amountController),
          const SizedBox(height: 10),
          UkTextField(
            hint: 'Comment',
            maxLines: 3,
            controller: commentController,
          ),
          const SizedBox(height: 10),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF6873D1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: fetchInvoice,
                  child: const Text(
                    'Issue an invoice',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ))
        ],
      ),
    ));
  }
}

class IssueInvoiceList extends StatefulWidget {
  final List<Map<String, dynamic>> servicesList;
  const IssueInvoiceList({Key? key, required this.servicesList})
      : super(key: key);

  @override
  _IssueInvoiceListState createState() => _IssueInvoiceListState();
}

class _IssueInvoiceListState extends State<IssueInvoiceList> {
  String? selectedServiceId;

  @override
  void initState() {
    super.initState();
    if (widget.servicesList.isNotEmpty) {
      selectedServiceId = widget.servicesList.first['id'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: widget.servicesList.map((service) {
        bool isSelected = service['id'] == selectedServiceId;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedServiceId = service['id'];
              print("Выбрана услуга с id: $selectedServiceId");
            });
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF7961BE)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              service['name'],
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w400),
            ),
          ),
        );
      }).toList(),
    );
  }
}
