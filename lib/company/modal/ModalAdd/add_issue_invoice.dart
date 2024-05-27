import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/service/dio_config.dart';

class ApartmentService {
  final int id;
  final String name;

  ApartmentService({required this.id, required this.name});

  factory ApartmentService.fromJson(Map<String, dynamic> json) {
    return ApartmentService(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class AddIssueInvoice extends StatefulWidget {
  final int id;
  const AddIssueInvoice({super.key, required this.id});

  @override
  State<AddIssueInvoice> createState() => _AddIssueInvoiceState();
}

class _AddIssueInvoiceState extends State<AddIssueInvoice> {
  final TextEditingController billNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  Map<String, dynamic> appartament = {};
  List<ApartmentService> combinedServiceList = [];

  ApartmentService? selectedService;

  @override
  void initState() {
    super.initState();
    _getInvoiceServiceList();
  }

  @override
  void dispose() {
    billNumberController.dispose();
    amountController.dispose();
    commentController.dispose();
    super.dispose();
  }

  void _showSuccessModal() {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const SuccessModal(
            message: "Invoice has been successfully issued.");
      },
    );
  }

  Future<void> _getInvoiceServiceList() async {
    try {
      final response = await DioSingleton()
          .dio
          .get('employee/apartments/apartment_info/${widget.id}/invoice');
      if (response.data != null && response.data.isNotEmpty) {
        var rawData = response.data[0];

        List<dynamic> serviceRawList =
            response.data[1]['services_list'][1]['service_list'] as List;
        List<dynamic> meterRawList =
            response.data[1]['services_list'][0]['meter_service_list'] as List;

        List<ApartmentService> services = serviceRawList
            .map((json) =>
                ApartmentService.fromJson(json as Map<String, dynamic>))
            .toList();
        List<ApartmentService> meters = meterRawList
            .map((json) =>
                ApartmentService.fromJson(json as Map<String, dynamic>))
            .toList();

        List<ApartmentService> combinedList = [];
        combinedList.addAll(services);
        combinedList.addAll(meters);

        setState(() {
          appartament = rawData;
          combinedServiceList = combinedList;
          selectedService = combinedList.isNotEmpty ? combinedList.first : null;
        });
      }
    } catch (e) {
      print("Ошибка при получении данных: $e");
    }
  }

  Future<void> fetchInvoice() async {
    if (selectedService == null) {
      print("No service selected");
      return;
    }

    final data = {
      "apartment_id": appartament['id'].toString(),
      "service_name": selectedService!.name,
      "service_id": selectedService!.id.toString(),
      "bill_number": billNumberController.text,
      "amount": amountController.text,
      "comment": commentController.text,
    };

    try {
      await DioSingleton().dio.post(
            'employee/apartments/apartment_info/${widget.id}/invoice',
            data: data,
          );
      if (mounted) {
        Navigator.pop(context);
        _showSuccessModal();
      }
    } catch (e) {
      print("Ошибка при отправке данных: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 18, left: 15, right: 15, bottom: 34),
      child: ListView(
        shrinkWrap: true,
        children: [
          const ModalHeader(title: 'Issue an invoice'),
          const SizedBox(height: 10),
          Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 13),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(14)),
            child: Text(appartament['name'] ?? 'No appartament'),
          ),
          IssueInvoiceList(
            servicesList: combinedServiceList,
            selectedService: selectedService,
            onSelected: (service) {
              setState(() => selectedService = service);
            },
          ),
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
          CustomBtn(
            title: 'Issue an invoice',
            onPressed: fetchInvoice,
            height: 55,
          )
        ],
      ),
    );
  }
}

class IssueInvoiceList extends StatelessWidget {
  final List<ApartmentService> servicesList;
  final ApartmentService? selectedService;
  final Function(ApartmentService) onSelected;

  const IssueInvoiceList({
    Key? key,
    required this.servicesList,
    this.selectedService,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 9.0,
      children: servicesList.map((service) {
        bool isSelected = service == selectedService;
        return GestureDetector(
          onTap: () => onSelected(service),
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF7961BE) : Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              service.name,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }).toList(),
    );
  }
}
