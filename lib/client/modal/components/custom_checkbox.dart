import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool isChecked;
  final Function(bool?)? onChanged;

  const CustomCheckbox({
    Key? key,
    required this.isChecked,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onChanged?.call(!widget.isChecked),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent, // Фон всегда прозрачный
          border: Border.all(
            color: Colors.black, // Цвет границы
            width: 2, // Ширина границы
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0), // Отступ внутри контейнера
          child: widget.isChecked
              ? const Icon(
                  Icons.check, // Иконка галочки
                  size: 16.0,
                  color: Colors.black,
                )
              : const SizedBox(
                  width: 16.0,
                  height: 16.0,
                  // Пустое место, если чекбокс не отмечен, сохраняя одинаковый размер и форму
                ),
        ),
      ),
    );
  }
}
