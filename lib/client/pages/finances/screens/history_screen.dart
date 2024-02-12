import 'package:flutter/material.dart';
import 'package:flutter_application/client/ui/CustomInkWell.dart'; // Убедитесь, что путь к файлу верный

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 20), // Добавляем отступ снизу
            child: CustomInkWell(
              title: 'June 2023',
              onTap: () {
                // Действие при нажатии
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 20), // Добавляем отступ снизу
            child: CustomInkWell(
              title: 'July 2023',
              onTap: () {
                // Действие при нажатии
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 20), // Добавляем отступ снизу
            child: CustomInkWell(
              title: 'August 2023',
              onTap: () {
                // Действие при нажатии
              },
            ),
          ),
        ],
      ),
    );
  }
}
