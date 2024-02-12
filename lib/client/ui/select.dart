import "package:flutter/material.dart";

class Select extends StatefulWidget {
  const Select({Key? key}) : super(key: key);

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  String dropdownValue = 'SMART 17';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Transform.rotate(
        angle: 90 * 3.1415926535897932 / 180, // Поворачиваем на 90 градусов
        child: const Icon(
          Icons.chevron_right,
          color: Colors.white, // Устанавливаем цвет иконки
        ),
      ),
      elevation: 16,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 18, // Размер шрифта для выбранного значения (label)
          fontWeight: FontWeight.bold),
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['SMART 17', 'SMART 18', 'SMART 19', 'SMART 20']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      dropdownColor: Color(0xFF18232D),
    );
  }
}
