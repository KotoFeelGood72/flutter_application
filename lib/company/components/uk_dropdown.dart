import 'package:flutter/material.dart';

class UkDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> itemsList;
  final String? selectedItemKey;
  final Function(String) onSelected;
  final String displayValueKey;
  final String valueKey;

  const UkDropdown({
    Key? key,
    required this.itemsList,
    required this.selectedItemKey,
    required this.onSelected,
    required this.displayValueKey,
    required this.valueKey,
  }) : super(key: key);

  @override
  _UkDropdownState createState() => _UkDropdownState();
}

class _UkDropdownState extends State<UkDropdown> {
  String? currentSelectedKey;

  @override
  void initState() {
    super.initState();
    currentSelectedKey = widget.selectedItemKey;
  }

  @override
  Widget build(BuildContext context) {
    // Пытаемся найти выбранный элемент по текущему выбранному ключу
    Map<String, dynamic>? selectedItem;
    try {
      selectedItem = widget.itemsList.firstWhere(
        (item) => item[widget.valueKey].toString() == currentSelectedKey,
      );
    } catch (e) {
      selectedItem = null;
    }

    // Используем значение выбранного элемента или null, если элемент не найден
    String? dropdownValue = selectedItem?[widget.displayValueKey];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          icon: const Icon(Icons.expand_more_rounded),
          iconSize: 20,
          elevation: 16,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),
          value: dropdownValue,
          onChanged: (String? newValue) {
            Map<String, dynamic>? newSelectedItem;
            for (var item in widget.itemsList) {
              if (item[widget.displayValueKey] == newValue) {
                newSelectedItem = item;
                break;
              }
            }

            if (newSelectedItem != null) {
              String keyValue = newSelectedItem[widget.valueKey].toString();
              setState(() {
                currentSelectedKey = keyValue;
              });
              widget.onSelected(keyValue);
            }
          },
          items: widget.itemsList
              .map<DropdownMenuItem<String>>((Map<String, dynamic> item) {
            return DropdownMenuItem<String>(
              value: item[widget.displayValueKey],
              child: Text(item[widget.displayValueKey]),
            );
          }).toList(),
        ),
      ),
    );
  }
}
