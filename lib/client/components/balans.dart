import 'package:auto_route/auto_route.dart';
import "package:flutter/material.dart";
import 'package:flutter_application/router/router.dart';

class Balans extends StatefulWidget {
  final String text; // Текстовое поле для отображения
  final double price; // Цена для отображения
  final bool showPayButton; // Флаг для отображения кнопки Pay

  const Balans({
    Key? key,
    required this.text,
    required this.price,
    this.showPayButton = true, // По умолчанию кнопка Pay отображается
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BalansState createState() => _BalansState();
}

class _BalansState extends State<Balans> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromRGBO(104, 115, 209, 0.58),
            Color.fromRGBO(54, 65, 75, 0.90),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 162,
                    child: Text(
                      widget.text, // Используем текст из параметра
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  if (!widget.showPayButton)
                    Text(
                      '\$ ${widget.price}', // Используем цену из параметра
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (widget.showPayButton) // Условное отображение кнопки
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(13, 255, 255, 255)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () {
                      AutoRouter.of(context).push(const FinancesRoute());
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 13, horizontal: 40),
                      child: Text(
                        'Pay',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                if (widget.showPayButton)
                  Text(
                    '\$ ${widget.price}', // Используем цену из параметра
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
