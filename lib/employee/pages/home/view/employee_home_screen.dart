import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/client/components/news.dart';
import 'package:flutter_application/employee/components/modal/employee_appartaments_modal.dart';
import 'package:flutter_application/components/access/access_item.dart';
import 'package:flutter_application/company/components/bar_chart.dart';

import 'package:flutter_application/employee/components/modal/employee_modal_executors.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';

@RoutePage()
class EmployeHomeMainScreen extends StatefulWidget {
  const EmployeHomeMainScreen({super.key});

  @override
  State<EmployeHomeMainScreen> createState() => _EmployeHomeMainScreenState();
}

class _EmployeHomeMainScreenState extends State<EmployeHomeMainScreen> {
  Map<String?, dynamic> userProfile = {};

  @override
  void initState() {
    super.initState();
    _getEmployee();
  }

  Future<void> _getEmployee() async {
    try {
      final response = await DioSingleton().dio.get('employee_info');
      setState(() {
        userProfile = response.data;
      });
    } catch (e) {
      print("Ошибка при получении информации о профиле: $e");
    }
  }

  final List<AccessItem> accessItems = [
    AccessItem(
      title: 'Apartments',
      routeName: 'maintenanceRoute',
      imageAssets: [
        'assets/img/appartaments.png',
        'assets/img/appartaments1.png'
      ],
    ),
    AccessItem(
      title: 'Executors',
      routeName: 'maintenanceRoute',
      imageAssets: ['assets/img/executors.png', 'assets/img/executors1.png'],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 250,
              color: const Color(0xFF18232D),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 250,
                                child: Text(
                                  '${userProfile['firstname']} ${userProfile['lastname']}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 250,
                                child: Text(
                                  'Attached object',
                                  style: TextStyle(color: Color(0xFFA5A5A7)),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              AutoRouter.of(context).push(EmployProfileRoute());
                            },
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Image.asset(
                                  'assets/img/user.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const StatisticBar(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 15,
                right: 15,
                bottom: 20,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (accessItems.length / 2).ceil(),
                itemBuilder: (context, index) {
                  int firstItemIndex = index * 2;
                  int? secondItemIndex = firstItemIndex + 1 < accessItems.length
                      ? firstItemIndex + 1
                      : null;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: AccessItemWidget(
                          item: accessItems[firstItemIndex],
                          index: firstItemIndex,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              builder: (BuildContext context) {
                                return const EmployeeAppartamentsModal();
                              },
                            );
                          },
                        ),
                      ),
                      if (secondItemIndex != null) const SizedBox(width: 10),
                      if (secondItemIndex != null)
                        Expanded(
                          child: AccessItemWidget(
                            item: accessItems[secondItemIndex],
                            index: secondItemIndex,
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                builder: (BuildContext context) {
                                  return const EmployeModalExecutors();
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text('News()'),
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticBar extends StatelessWidget {
  const StatisticBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.only(bottom: 10, top: 10, right: 16, left: 16),
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
    );
  }
}
