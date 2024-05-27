// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
// import 'package:flutter_application/company/components/uk_dropdown.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/models/Appartments.dart';
import 'package:flutter_application/service/dio_config.dart';

// class Appartaments {
//   final int id;
//   final String name;

//   Appartaments({required this.id, required this.name});

//   factory Appartaments.fromJson(Map<String, dynamic> json) {
//     return Appartaments(
//         id: json['id'] as int, name: json['apartment_name'] as String);
//   }
// }

class AddMeterModal extends StatefulWidget {
  final int id;
  const AddMeterModal({Key? key, required this.id}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddMeterModalState createState() => _AddMeterModalState();
}

class _AddMeterModalState extends State<AddMeterModal> {
  Appartaments? appartament;
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
    _handleMeterIdChange('1');
    _getAppartaments();
  }

  Future<void> _getAppartaments() async {
    try {
      final response = await DioSingleton()
          .dio
          .get('employee/apartments/apartment_info/${widget.id}');
      if (response.data != null && response.data.isNotEmpty) {
        setState(() {
          appartament = Appartaments.fromJson(response.data);
        });
      }
    } catch (e) {
      print("Ошибка при получении данных: $e");
    }
  }

  Future<void> fetchMeter() async {
    try {
      final data = {
        "apartment_id": appartament!.id,
        "meter_id": selectedMeterId,
        "bill_number": billNumber.text,
        "month_year": monthYear.text,
        "meter_readings": meterReadings.text,
        "comment": comment.text,
      };

      await DioSingleton().dio.post(
          'employee/apartments/apartment_info/${widget.id}/enter_meters',
          data: data);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const SuccessModal(
              message: "Invoice has been successfully issued.");
        },
      );
    } catch (e) {
      // ignore: avoid_print
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
          const SizedBox(height: 10),
          if (appartament != null)
            Container(
              height: 50,
              margin: const EdgeInsets.only(bottom: 13),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14)),
              child: Text(appartament!.name),
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
          CustomBtn(
            title: 'Enter meter readings',
            onPressed: fetchMeter,
            height: 55,
          )
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
  // ignore: library_private_types_in_public_api
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
      children: [
        for (int i = 0; i < widget.meterList.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedMeterId = widget.meterList[i]['id'];
                });
                widget.onUpdateSelectedMeterId(widget.meterList[i]['id']);
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  border: widget.meterList[i]['id'] == selectedMeterId
                      ? Border.all(color: const Color(0xFF92D0EA))
                      : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.meterList[i]['name'],
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }
}
