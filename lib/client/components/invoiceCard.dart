import 'package:flutter/material.dart';

class InvoiceComponent extends StatelessWidget {
  final String title;
  final String price;

  InvoiceComponent({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Image.asset('assets/img/invoice.png')),
              SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(), // Добавляем Divider внизу
        ],
      ),
    );
  }
}
