// import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_application/client/components/invoiceCard.dart';

// @RoutePage()
class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  bool _isListVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'First name Last name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                child: TextButton(
                  onPressed: () {
                    // Изменяем состояние для переключения видимости списка
                    setState(() {
                      _isListVisible = !_isListVisible;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize
                        .min, // Уменьшаем размер Column до содержимого
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Центрируем содержимое
                    children: <Widget>[
                      Container(
                          child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFF5F5F5)),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              top: 2, bottom: 2, left: 10, right: 10),
                          child: Text(
                            "3 696,13 \$",
                            style: TextStyle(color: Color(0xFF5D5D67)),
                          ),
                        ),
                      )), // Текст
                      Transform.rotate(
                        angle: _isListVisible
                            ? math.pi / 2 * 3
                            : math.pi /
                                2, // Поворачиваем стрелку вверх или вниз
                        child: const Icon(Icons.chevron_left), // Используем ик
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isListVisible)
            Expanded(
              child: ListView(
                children: [
                  InvoiceComponent(
                    title: 'Invoice #123',
                    price: '1 381,7 \$',
                  ),
                  InvoiceComponent(
                    title: 'Invoice #123',
                    price: '1 381,7 \$',
                  ),
                  InvoiceComponent(
                    title: 'Invoice #123',
                    price: '1 381,7 \$',
                  ),
                  InvoiceComponent(
                    title: 'Invoice #123',
                    price: '1 381,7 \$',
                  ),
                ],
              ),
            ),
        ],
      )),
    );
  }
}
