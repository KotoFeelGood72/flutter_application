import 'package:flutter/material.dart';
import 'package:flutter_application/company/modal/ModalInfo/payment/info_paid_modal.dart';
import 'package:flutter_application/company/modal/service/service_state_item.dart';
import 'package:flutter_application/models/Payment.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/empty_state.dart';

class PaidPaymentScreen extends StatefulWidget {
  final int id;
  const PaidPaymentScreen({super.key, required this.id});

  @override
  State<PaidPaymentScreen> createState() => _PaidPaymentScreenState();
}

class _PaidPaymentScreenState extends State<PaidPaymentScreen> {
  DayList? payments;
  bool isLoading = true;

  Future<void> _getInvoiceUnPaid() async {
    try {
      final response = await DioSingleton().dio.get(
          'employee/apartments/apartment_info/${widget.id}/payment-history/paid');
      if (response.data != null) {
        setState(() {
          payments = DayList.fromJson(response.data as List<dynamic>);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Ошибка при получении данных: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getInvoiceUnPaid();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (payments == null || payments!.days.isEmpty) {
      return const EmptyState(
        title: "No payment information available",
        text: '',
        url:
            'https://lottie.host/5268f534-057c-41e8-a452-caae0c1a1307/8G8EI88wA5.json',
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: payments!.days.length,
        itemBuilder: (context, index) {
          final day = payments!.days[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  day.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: day.services.length,
                itemBuilder: (context, serviceIndex) {
                  final service = day.services[serviceIndex];
                  return ServiceStateItem(
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          builder: (BuildContext context) {
                            return InfoPaidModal(
                              id: service.id,
                              appartamentId: widget.id,
                            );
                          },
                        );
                      },
                      name: service.apartmentName,
                      id: service.id.toString(),
                      time: service.createdAt,
                      statusOther: service.status,
                      price: 'The amount');
                },
              ),
            ],
          );
        },
      );
    }
  }
}
