import 'package:flutter/material.dart';
import 'dart:math' as math;

class BarChart extends StatelessWidget {
  final List<double> data;
  final double maxWidth;

  const BarChart({
    Key? key,
    required this.data,
    this.maxWidth = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double maxValue = data.reduce(math.max);

    return SizedBox(
      width: 105,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children:
            data.map((value) => _buildBar(value, context, maxValue)).toList(),
      ),
    );
  }

  Widget _buildBar(double value, BuildContext context, double maxValue) {
    return Flexible(
      child: Container(
        width: maxWidth,
        height: (value / maxValue) * 47,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.2),
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
