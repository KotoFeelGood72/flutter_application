import 'package:flutter/material.dart';

class InfoPaidModal extends StatefulWidget {
  const InfoPaidModal({super.key});

  @override
  State<InfoPaidModal> createState() => _InfoPaidModalState();
}

class _InfoPaidModalState extends State<InfoPaidModal> {
  Color _amountTextColor = Color(0xFF61BE75);
  String _activeButton = 'Paid';

  void _changeAmountTextColor(Color color, String buttonTitle) {
    setState(() {
      _amountTextColor = color;
      _activeButton = buttonTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: const Text(
              '12-2 Floor-2nd, Smart, 17',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: const Text(
              '№ 929809',
              style: TextStyle(color: Color(0xFFA5A5A7), fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 11),
            child: const Text(
              'Electricity',
              style: TextStyle(color: Color(0xFFA5A5A7), fontSize: 12),
            ),
          ),
          Container(
            width: 88,
            height: 88,
            margin: EdgeInsets.only(bottom: 10),
            child: Image.asset(
              'assets/img/cleaning.png',
              fit: BoxFit.contain,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 15, bottom: 18),
            child: Text(
              'The amount',
              style: TextStyle(
                  color: _amountTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            color: Color(0xFFF5F5F5),
            padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 50),
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
                          style:
                              TextStyle(color: Color(0xFFA5A5A7), fontSize: 12),
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
                          style:
                              TextStyle(color: Color(0xFFA5A5A7), fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 29),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBigBtn(
                      title: 'Unpaid',
                      borderColor: Color(0xFFBE6161),
                      titleColor: Color(0xFFBE6161),
                      backgroundColor: Colors.white,
                      onTap: () =>
                          _changeAmountTextColor(Color(0xFFBE6161), 'Unpaid'),
                      isActive: _activeButton == 'Unpaid',
                    ),
                    CustomBigBtn(
                      title: 'Paid',
                      borderColor: Color(0xFF61BE75),
                      titleColor: Color(0xFF61BE75),
                      backgroundColor: Colors.white,
                      onTap: () =>
                          _changeAmountTextColor(Color(0xFF61BE75), 'Paid'),
                      isActive: _activeButton == 'Paid',
                    )
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

class CustomBigBtn extends StatelessWidget {
  final String title;
  final Color borderColor;
  final Color backgroundColor;
  final Color titleColor;
  final VoidCallback onTap;
  final bool isActive;
  final double? width;

  const CustomBigBtn({
    super.key,
    required this.title,
    required this.borderColor,
    required this.backgroundColor,
    required this.titleColor,
    required this.onTap,
    this.isActive = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border:
              Border.all(color: isActive ? borderColor : Colors.transparent),
          color: backgroundColor,
        ),
        padding: EdgeInsets.symmetric(vertical: 17, horizontal: 57),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 16, color: titleColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
