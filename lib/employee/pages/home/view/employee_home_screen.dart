import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/client/components/news.dart';
import 'package:flutter_application/company/modal/appartaments_modal.dart';
import 'package:flutter_application/components/bottom_admin_bar.dart';
import 'package:flutter_application/components/ui/profile_avatar.dart';
import 'package:flutter_application/components/ui/statistic_bar.dart';
import 'package:flutter_application/components/access/access_item.dart';
import 'package:flutter_application/employee/bloc/employee_bloc.dart';
import 'package:flutter_application/employee/components/modal/employee_modal_executors.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class EmployeHomeMainScreen extends StatefulWidget {
  const EmployeHomeMainScreen({super.key});

  @override
  State<EmployeHomeMainScreen> createState() => _EmployeHomeMainScreenState();
}

class _EmployeHomeMainScreenState extends State<EmployeHomeMainScreen> {
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
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(EmployeeLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeDataLoaded) {
            final userProfile = state.employeeInfo;
            return ListView(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: 250,
                                    child: Text(
                                      '${userProfile.firstname} ${userProfile.lastname}',
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
                                      userProfile.objectName,
                                      style:
                                          TextStyle(color: Color(0xFFA5A5A7)),
                                    ),
                                  ),
                                ],
                              ),
                              ProfileAvatar(
                                photoUrl: userProfile.photoPath ?? '',
                                route: EmployProfileRoute(),
                              ),
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
                      int? secondItemIndex =
                          firstItemIndex + 1 < accessItems.length
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
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  builder: (BuildContext context) {
                                    return const AppartamentsModal(
                                        type: 'employee');
                                  },
                                );
                              },
                            ),
                          ),
                          if (secondItemIndex != null)
                            const SizedBox(width: 10),
                          if (secondItemIndex != null)
                            Expanded(
                              child: AccessItemWidget(
                                item: accessItems[secondItemIndex],
                                index: secondItemIndex,
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
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
                  child: News(type: ''),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
      bottomNavigationBar: const BottomAdminBar(),
    );
  }
}

class ListInfoItem extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback? onTap;

  const ListInfoItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF5F5F5),
        ),
        child: ListTile(
          leading: Image.asset(icon),
          title: Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
