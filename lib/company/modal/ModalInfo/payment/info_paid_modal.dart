import 'package:flutter/material.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/models/Payment.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/empty_state.dart';

class InfoPaidModal extends StatefulWidget {
  final int id;
  final int appartamentId;
  const InfoPaidModal(
      {super.key, required this.id, required this.appartamentId});

  @override
  State<InfoPaidModal> createState() => _InfoPaidModalState();
}

class _InfoPaidModalState extends State<InfoPaidModal> {
  Color _amountTextColor = const Color(0xFF61BE75);
  String _activeButton = 'Paid';
  SinglePayment? singlePatments;
  bool isLoading = true;

  void _showSuccessModal() {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const SuccessModal(message: "Invoice has been changed");
      },
    );
  }

  Future<void> _getInvoice() async {
    try {
      final response = await DioSingleton().dio.get(
          'employee/apartments/apartment_info/${widget.appartamentId}/payment-history/${widget.id}');
      if (response.data != null) {
        setState(() {
          singlePatments = SinglePayment.fromJson(response.data);
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

  Future<void> _updateInvoice(bool isPaid) async {
    try {
      final String status = isPaid ? 'paid' : 'unpaid';
      await DioSingleton().dio.post(
        'employee/apartments/apartment_info/${widget.appartamentId}/payment-history/${widget.id}/$status',
        data: {'apartment_id': widget.appartamentId, 'invoice_id': widget.id},
      );
      Navigator.pop(context);
      _showSuccessModal();
    } catch (e) {
      print("Ошибка при обновлении счета: $e");
      // Обработка ошибки
    }
  }

  @override
  void initState() {
    super.initState();
    _getInvoice();
  }

  void _changeAmountTextColor(Color color, String buttonTitle) {
    setState(() {
      _amountTextColor = color;
      _activeButton = buttonTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (singlePatments == null) {
      return const EmptyState(
        title: "No payment information available",
        text: '',
        url:
            'https://lottie.host/5268f534-057c-41e8-a452-caae0c1a1307/8G8EI88wA5.json',
      );
    } else {
      return Container(
        constraints: BoxConstraints(maxHeight: 500),
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                '№ ${singlePatments!.id.toString()}',
                style: const TextStyle(color: Color(0xFFA5A5A7), fontSize: 12),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 11),
              child: Text(
                singlePatments!.serviceName,
                style: const TextStyle(color: Color(0xFFA5A5A7), fontSize: 12),
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
                  const SizedBox(height: 29),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomBigBtn(
                          title: 'Unpaid',
                          borderColor: const Color(0xFFBE6161),
                          titleColor: const Color(0xFFBE6161),
                          backgroundColor: Colors.white,
                          onTap: () => _updateInvoice(false),
                          isActive: _activeButton == 'Unpaid',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomBigBtn(
                          title: 'Paid',
                          borderColor: const Color(0xFF61BE75),
                          titleColor: const Color(0xFF61BE75),
                          backgroundColor: Colors.white,
                          onTap: () => _updateInvoice(true),
                          isActive: _activeButton == 'Paid',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}

class CustomBigBtn extends StatelessWidget {
  final String title;
  final Color borderColor;
  final Color backgroundColor;
  final Color titleColor;
  final VoidCallback? onTap;
  final bool isActive;
  final bool isLoading;
  final double? width;

  const CustomBigBtn({
    super.key,
    required this.title,
    required this.borderColor,
    required this.backgroundColor,
    required this.titleColor,
    this.onTap,
    this.isActive = false,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: isLoading ? null : onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border:
              Border.all(color: isActive ? borderColor : Colors.transparent),
          color: backgroundColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 57),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              Container(
                margin: const EdgeInsets.only(right: 10),
                width: 16,
                height: 16,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 16, color: titleColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
