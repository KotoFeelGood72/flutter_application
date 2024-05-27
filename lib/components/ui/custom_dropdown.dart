import 'package:flutter/material.dart';
import 'package:flutter_application/models/user_item_news.dart';

class CustomDropdown extends StatefulWidget {
  final List<UserItemNews> list;
  final Function(UserItemNews) onChanged;
  final UserItemNews? initialValue;

  const CustomDropdown({
    Key? key,
    required this.list,
    required this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  UserItemNews? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue =
        widget.initialValue ?? (widget.list.isNotEmpty ? widget.list[0] : null);

    // Отладочная информация
    print('Initial dropdown value: ${dropdownValue?.name}');
    print('Dropdown list: ${widget.list.map((e) => e.name).toList()}');
  }

  @override
  Widget build(BuildContext context) {
    // Дополнительный вывод отладочной информации при изменении значений
    print('Building CustomDropdown with value: ${dropdownValue?.name}');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<UserItemNews>(
          value: dropdownValue,
          icon: const Icon(Icons.expand_more_sharp),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (UserItemNews? newValue) {
            setState(() {
              dropdownValue = newValue;
            });
            // Отладочная информация при изменении значения
            print('Selected new value: ${newValue?.name}');
            widget.onChanged(newValue!);
          },
          items: widget.list
              .map<DropdownMenuItem<UserItemNews>>((UserItemNews value) {
            return DropdownMenuItem<UserItemNews>(
              value: value,
              child: Text(value.name),
            );
          }).toList(),
          decoration: const InputDecoration.collapsed(hintText: ''),
          menuMaxHeight: 200, // Ограничение по высоте
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        dropdownValue = widget.initialValue;
      });
    }
  }
}
