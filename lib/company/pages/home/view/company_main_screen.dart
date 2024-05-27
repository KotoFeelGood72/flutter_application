import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/bloc/company_bloc.dart';
import 'package:flutter_application/models/CompanyInfo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application/client/components/news.dart';
import 'package:flutter_application/components/access/access_item.dart';
import 'package:flutter_application/company/components/add_btn.dart';
import 'package:flutter_application/company/components/requisites_card.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_employe_modal.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_news_modal.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_object_modal.dart';
import 'package:flutter_application/company/modal/employ_object_modal.dart';
import 'package:flutter_application/company/modal/employ_staff_modal.dart';
import 'package:flutter_application/components/bottom_admin_bar.dart';
import 'package:flutter_application/components/ui/profile_avatar.dart';
import 'package:flutter_application/components/ui/statistic_bar.dart';
import 'package:flutter_application/router/router.dart';

@RoutePage()
class CompanyHomeMainScreen extends StatefulWidget {
  const CompanyHomeMainScreen({super.key});

  @override
  State<CompanyHomeMainScreen> createState() => _CompanyHomeMainScreenState();
}

class _CompanyHomeMainScreenState extends State<CompanyHomeMainScreen> {
  CompanyInfo? company;
  @override
  void initState() {
    super.initState();
    context.read<CompanyBloc>().add(CompanyLoaded());
  }

  @override
  void dispose() {
    super.dispose();
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
      body: BlocBuilder<CompanyBloc, CompanyState>(
        builder: (context, state) {
          if (state is CompanyInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CompanyStateData) {
            company = state!.company;
            return ListView(
              children: [
                Container(
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
                              InkWell(
                                hoverColor: Colors.transparent,
                                onTap: () {},
                                child: SizedBox(
                                  width: 200,
                                  child: Text(
                                    '${company!.ukName ?? ''}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              ProfileAvatar(
                                photoUrl: company!.photoPath,
                                route: CompanyProfileRoute(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const StatisticBar(),
                        const SizedBox(height: 10),
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
                            isScrollControlled: true,
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
                              return const AddNewsModal();
                            },
                          );
                        }),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: News(type: ''),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: RequisitesCard(content: company!.requisites),
                ),
              ],
            );
          } else {
            return Center(child: Text('Failed to load company info'));
          }
        },
      ),
      bottomNavigationBar: BottomAdminBar(),
    );
  }
}
