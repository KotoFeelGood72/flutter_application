import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/client/components/news.dart';
import 'package:flutter_application/company/modal/ModalInfo/info_metter_modal.dart';
import 'package:flutter_application/company/modal/ModalInfo/info_order_modal.dart';
import 'package:flutter_application/company/modal/ModalInfo/payment/info_paid_modal.dart';
import 'package:flutter_application/company/modal/ModalInfo/payment/info_payment_modal.dart';
import 'package:flutter_application/components/access/access_item.dart';
import 'package:flutter_application/company/components/add_btn.dart';
import 'package:flutter_application/company/components/bar_chart.dart';
import 'package:flutter_application/company/components/requisites_card.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_employe_modal.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_news_modal.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_object_modal.dart';
import 'package:flutter_application/company/modal/employ_object_modal.dart';
import 'package:flutter_application/company/modal/employ_staff_modal.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';

@RoutePage()
class CompanyHomeMainScreen extends StatefulWidget {
  const CompanyHomeMainScreen({super.key});

  @override
  State<CompanyHomeMainScreen> createState() => _CompanyHomeMainScreenState();
}

class _CompanyHomeMainScreenState extends State<CompanyHomeMainScreen> {
  Map<String?, dynamic> company = {};

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    try {
      final response = await DioSingleton().dio.get('get_profile_uk');
      setState(() {
        company = response.data;
      });
    } catch (e) {
      print("Ошибка при получении информации о профиле: $e");
    }
  }

  final List<AccessItem> accessItems = [
    AccessItem(
      title: 'Staff',
      routeName: 'maintenanceRoute',
      imageAssets: ['assets/img/staff.png', 'assets/img/staff1.png'],
    ),
    AccessItem(
      title: 'Objects',
      routeName: 'maintenanceRoute',
      imageAssets: ['assets/img/objects.png', 'assets/img/objects1.png'],
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
                          SizedBox(
                            width: 200,
                            child: Text(
                              '${company['UK name']}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              AutoRouter.of(context)
                                  .push(CompanyProfileRoute());
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
                                return const EmployStaffModal(
                                  apiUrl: 'get_staff_uk',
                                );
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
                                  return const EmployObjectModal();
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
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AddBtn(
                  title: 'Add an \nemployee',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      builder: (BuildContext context) {
                        return const AddEmployeModal();
                      },
                    );
                  },
                ),
                AddBtn(
                    title: 'Add an \nobject',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        builder: (BuildContext context) {
                          return const AddObjectModal();
                        },
                      );
                    }),
                AddBtn(
                    title: 'Add \nNews',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        builder: (BuildContext context) {
                          return AddNewsModal();
                        },
                      );
                    }),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text('News()'),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: RequisitesCard(content: company),
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
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      builder: (BuildContext context) {
                        return const InfoPaidModal();
                      },
                    );
                  },
                  child: Image.asset(
                    'assets/img/chevron_right.png',
                    width: 13,
                    height: 12,
                  ),
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
