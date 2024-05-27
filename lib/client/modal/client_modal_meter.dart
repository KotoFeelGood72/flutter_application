import 'package:flutter/material.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/models/Payment.dart';
import 'package:flutter_application/service/dio_config.dart';

// class ClientModalOrderInfo {
//   final String name;
//   final String status;
//   final String coment;
//   final int id;
//   final String iconPath;
// }

class ClientModalMeter extends StatefulWidget {
  final int id;
  const ClientModalMeter({
    super.key,
    required this.id,
  });

  @override
  State<ClientModalMeter> createState() => _ClientModalMeterState();
}

class _ClientModalMeterState extends State<ClientModalMeter> {
  Color _amountTextColor = const Color(0xFF61BE75);
  String _activeButton = 'Paid';
  SinglePayment? singlePatments;

  void _showSuccessModal() {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const SuccessModal(message: "Invoice has been changed");
      },
    );
  }

  Future<void> _getMettersId() async {
    try {
      final response =
          await DioSingleton().dio.get('client/meters/${widget.id}');
      if (response.data != null) {
        setState(() {
          singlePatments = SinglePayment.fromJson(response.data);
        });
      }
    } catch (e) {
      // print("Ошибка при получении данных: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getMettersId();
  }

  void _changeAmountTextColor(Color color, String buttonTitle) {
    setState(() {
      _amountTextColor = color;
      _activeButton = buttonTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return singlePatments == null
        ? const Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.only(top: 25),
            color: Colors.white,
            child: ListView(
              shrinkWrap: true,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 27),
                      width: 54,
                      height: 5,
                      decoration: BoxDecoration(
                          color: const Color(0xFFDCDCDC),
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    singlePatments!.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '№ ${singlePatments!.id.toString()}',
                    style:
                        const TextStyle(color: Color(0xFFA5A5A7), fontSize: 12),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 11),
                  child: Text(
                    singlePatments!.serviceName,
                    style:
                        const TextStyle(color: Color(0xFFA5A5A7), fontSize: 12),
                  ),
                ),
                Container(
                  width: 88,
                  height: 88,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Image.network(
                    singlePatments!.img,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 15, bottom: 18),
                  child: Text(
                    singlePatments!.amount.toString(),
                    style: TextStyle(
                        color: _amountTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  color: const Color(0xFFF5F5F5),
                  padding: const EdgeInsets.only(
                      top: 20, left: 15, right: 15, bottom: 50),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Purpose of payment',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'November, 2023',
                                style: TextStyle(
                                    color: Color(0xFFA5A5A7), fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Purpose of payment',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'November, 2023',
                                style: TextStyle(
                                    color: Color(0xFFA5A5A7), fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
