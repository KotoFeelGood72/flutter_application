import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/components/uk_dropdown.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/service/dio_config.dart';

class AddMeterModal extends StatefulWidget {
  final int id;
  const AddMeterModal({Key? key, required this.id}) : super(key: key);

  @override
  _AddMeterModalState createState() => _AddMeterModalState();
}

class _AddMeterModalState extends State<AddMeterModal> {
  List<Map<String, dynamic>> apartmentsList = [];
  final TextEditingController billNumber = TextEditingController();
  final TextEditingController monthYear = TextEditingController();
  final TextEditingController meterReadings = TextEditingController();
  final TextEditingController comment = TextEditingController();
  String selectedApartmentId = '';
  String? selectedMeterId;

  List<Map<String, dynamic>> meterList = [
    {'name': 'Electricity', 'id': '1'},
    {'name': 'Water', 'id': '2'},
    {'name': 'Internet', 'id': '3'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getApartmentsList());
  }

  Future<void> _getApartmentsList() async {
    try {
      final response = await DioSingleton()
          .dio
          .get('get_objects_uk/${widget.id}/apartment_list');
      if (response.data != null && response.data['apartments'] is List) {
        setState(() {
          apartmentsList =
              List<Map<String, dynamic>>.from(response.data['apartments']);
          selectedApartmentId = apartmentsList.first['id'].toString();
          selectedMeterId = meterList.first['id'];
        });
      }
    } catch (e) {
      print("Ошибка при получении данных: $e");
    }
  }

  Future<void> fetchMeter() async {
    try {
      final data = {
        "apartment_id": int.parse(selectedApartmentId),
        "meter_id": selectedMeterId,
        "bill_number": billNumber.text,
        "month_year": monthYear.text,
        "meter_readings": meterReadings.text,
        "comment": comment.text,
      };

      await DioSingleton().dio.post(
          'employee/apartments/apartment_info/${widget.id}/enter_meters',
          data: data);
      print(data);
      Navigator.pop(context);
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SuccessModal(message: "Invoice has been successfully issued.");
        },
      );
    } catch (e) {
      print("Ошибка при отправке данных: $e");
    }
  }

  void _handleMeterIdChange(String meterId) {
    if (mounted) {
      setState(() {
        selectedMeterId = meterId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.only(top: 18, left: 15, right: 15, bottom: 34),
      child: ListView(
        children: [
          const ModalHeader(title: 'Enter meter readings'),
          UkDropdown(
            itemsList: apartmentsList,
            selectedItemKey: "1",
            onSelected: (selectedId) {},
            displayValueKey: "apartment_name",
            valueKey: "id",
          ),
          IssueInvoiceList(
            meterList: meterList,
            onUpdateSelectedMeterId: _handleMeterIdChange,
          ),
          const SizedBox(height: 7),
          UkTextField(
            hint: 'Bill number',
            controller: billNumber,
          ),
          const SizedBox(height: 7),
          UkTextField(
            hint: 'Month, year',
            isDateField: true,
            controller: monthYear,
          ),
          const SizedBox(height: 7),
          UkTextField(
            hint: 'Meter readings',
            controller: meterReadings,
          ),
          const SizedBox(height: 7),
          UkTextField(
            hint: 'Comment',
            maxLines: 3,
            controller: comment,
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
                  onPressed: fetchMeter,
                  child: const Text(
                    'Enter meter readings',
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
  final Function(String) onUpdateSelectedMeterId;
  final List<Map<String, dynamic>> meterList;
  const IssueInvoiceList(
      {Key? key,
      required this.onUpdateSelectedMeterId,
      required this.meterList})
      : super(key: key);

  @override
  _IssueInvoiceListState createState() => _IssueInvoiceListState();
}

class _IssueInvoiceListState extends State<IssueInvoiceList> {
  String? selectedMeterId;

  @override
  void initState() {
    super.initState();
    if (widget.meterList.isNotEmpty) {
      selectedMeterId = widget.meterList.first['id'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget.meterList.map((meter) {
        bool isSelected = meter['id'] == selectedMeterId;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedMeterId = meter['id'];
                print("Выбрана услуга с id: $selectedMeterId");
              });
            },
            child: Container(
              alignment: Alignment.center,
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                border:
                    isSelected ? Border.all(color: Color(0xFF92D0EA)) : null,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                meter['name'],
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
