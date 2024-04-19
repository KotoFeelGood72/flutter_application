import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  final String leftTabName;
  final String rightTabName;
  final bool initialValue;
  final Function(bool) onToggle;

  ToggleSwitch({
    Key? key,
    required this.leftTabName,
    required this.rightTabName,
    required this.initialValue,
    required this.onToggle,
  }) : super(key: key);

  @override
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  late bool isEmailActive;

  @override
  void initState() {
    super.initState();
    isEmailActive = widget.initialValue;
  }

  void _toggleActive() {
    setState(() {
      isEmailActive = !isEmailActive;
      widget.onToggle(isEmailActive);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 7, right: 12, left: 12, bottom: 7),
      width: double.infinity,
      height: 47,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xFFF5F5F5),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (isEmailActive) {
                  _toggleActive();
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isEmailActive ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Text(
                  widget.leftTabName, // Используйте переданное имя
                  style: TextStyle(
                    color: !isEmailActive ? Colors.black : Color(0xFF6C6770),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isEmailActive) {
                  _toggleActive();
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isEmailActive ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Text(
                  widget.rightTabName, // Используйте переданное имя
                  style: TextStyle(
                    color: isEmailActive ? Colors.black : Color(0xFF6C6770),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
