import 'package:flutter/material.dart';

class UkDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> itemsList;
  final String? selectedItemKey;
  final Function(String) onSelected;
  final String displayValueKey;
  final String valueKey;
  final bool isEnabled;

  const UkDropdown({
    Key? key,
    required this.itemsList,
    required this.selectedItemKey,
    required this.onSelected,
    required this.displayValueKey,
    required this.valueKey,
    this.isEnabled = true, // default value is true to enable the dropdown
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
    Map<String, dynamic>? selectedItem;
    try {
      selectedItem = widget.itemsList.firstWhere(
        (item) => item[widget.valueKey].toString() == currentSelectedKey,
      );
    } catch (e) {
      selectedItem = null;
    }

    String? dropdownValue = selectedItem != null
        ? '${selectedItem!['first_name']} ${selectedItem!['last_name']}'
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      decoration: BoxDecoration(
        color: widget.isEnabled
            ? const Color(0xFFF5F5F5)
            : const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          icon: const Icon(Icons.expand_more_rounded),
          iconSize: 20,
          elevation: 16,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          value: dropdownValue,
          onChanged: widget.isEnabled
              ? (String? newValue) {
                  Map<String, dynamic>? newSelectedItem;
                  for (var item in widget.itemsList) {
                    if ('${item['first_name']} ${item['last_name']}' ==
                        newValue) {
                      newSelectedItem = item;
                      break;
                    }
                  }

                  if (newSelectedItem != null) {
                    String keyValue =
                        newSelectedItem[widget.valueKey].toString();
                    setState(() {
                      currentSelectedKey = keyValue;
                    });
                    widget.onSelected(keyValue);
                  }
                }
              : null,
          items: widget.itemsList
              .map<DropdownMenuItem<String>>((Map<String, dynamic> item) {
            return DropdownMenuItem<String>(
              value: '${item['first_name']} ${item['last_name']}',
              child: Text('${item['first_name']} ${item['last_name']}'),
            );
          }).toList(),
        ),
      ),
    );
  }
}
