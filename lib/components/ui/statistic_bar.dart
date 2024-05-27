import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/bar_chart.dart';
import 'package:flutter_application/router/router.dart';

class StatisticBar extends StatelessWidget {
  const StatisticBar({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        AutoRouter.of(context).push(const DevelopmentRoute());
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(125, 54, 65, 75),
              Color.fromARGB(83, 104, 115, 209),
            ],
          ),
        ),
        padding:
            const EdgeInsets.only(bottom: 10, top: 10, right: 16, left: 16),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 35,
                    child: Text(
                      'Statistic',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/img/chevron_right.png',
                    width: 13,
                    height: 12,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/img/stat.png',
                ),
                const BarChart(data: [8, 10, 15, 20, 15]),
              ],
            )
          ],
        ),
      ),
    );
  }
}
