import 'package:flutter/material.dart';
import 'package:flutter_application/client/modal/components/custom_checkbox.dart';

class ServiceItem extends StatefulWidget {
  final String serviceName;
  final dynamic price;
  final bool isCountable;
  final Function(
          bool isChecked, String serviceName, double price, int quantity)?
      onSelected;

  const ServiceItem({
    Key? key,
    required this.serviceName,
    required this.price,
    this.isCountable = false,
    this.onSelected,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ServiceItemState createState() => _ServiceItemState();
}

class _ServiceItemState extends State<ServiceItem> {
  bool isChecked = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    // Проверяем, что price не null и преобразуем в double, если это int
    double price = widget.price is int ? widget.price.toDouble() : widget.price;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(245, 245, 245, 1),
        borderRadius: BorderRadius.circular(14),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            isChecked = !isChecked;
          });
          // Вызываем callback, передавая price как double
          widget.onSelected
              ?.call(isChecked, widget.serviceName, price, quantity);
        },
        child: ListTile(
          leading: Transform.scale(
            scale: 1.2,
            child: CustomCheckbox(
              isChecked: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value ?? false;
                });
                widget.onSelected
                    ?.call(isChecked, widget.serviceName, price, quantity);
              },
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(widget.serviceName),
              ),
              if (widget.isCountable) ...[
                _buildCountable(price),
                const SizedBox(width: 10),
                Text(
                  '${(price * quantity).toStringAsFixed(2)} \$',
                  style: const TextStyle(fontSize: 14),
                ),
              ] else
                Text(
                  '${price.toStringAsFixed(2)} \$',
                  style: const TextStyle(fontSize: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountable(double price) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildActionButton(
            icon: Icons.remove,
            onPressed: () {
              if (quantity > 1) {
                setState(() {
                  quantity--;
                });
                widget.onSelected
                    ?.call(isChecked, widget.serviceName, price, quantity);
              }
            }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            quantity.toString(),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        _buildActionButton(
            icon: Icons.add,
            onPressed: () {
              setState(() {
                quantity++;
              });
              widget.onSelected
                  ?.call(isChecked, widget.serviceName, price, quantity);
            }),
      ],
    );
  }

  Widget _buildActionButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(100),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Icon(
          icon,
          size: 18,
        ),
      ),
    );
  }
}
