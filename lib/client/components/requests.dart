import "package:flutter/material.dart";

class Requests extends StatefulWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  int activeRequest = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Colors.white.withOpacity(0.07)), // Фон кнопки
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Радиус границы
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.all(20)), // Внутренний отступ для всей кнопки
          ),
          icon: Padding(
              padding: const EdgeInsets.only(right: 3),
              child:
                  Image.asset('assets/img/file.png')), // Иконка перед текстом
          label: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$activeRequest active requests',
                style: TextStyle(color: Colors.white),
              )), // Текст на кнопке
          onPressed: () {
            // Действие при нажатии на кнопку
          },
        )
      ],
    );
  }
}
