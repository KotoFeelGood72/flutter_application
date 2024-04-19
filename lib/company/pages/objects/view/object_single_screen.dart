import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/modal/appartaments_modal.dart';
import 'package:flutter_application/company/modal/employ_object_modal.dart';
import 'package:flutter_application/company/modal/employ_staff_modal.dart';
// import 'package:flutter_application/company/modal/employ_staff_modal.dart';
import 'package:flutter_application/components/access/access_item.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'dart:math' as math;

@RoutePage()
class ObjectSingleScreen extends StatefulWidget {
  final int id;
  const ObjectSingleScreen({Key? key, @PathParam('id') required this.id})
      : super(key: key);

  @override
  State<ObjectSingleScreen> createState() => _ObjectSingleScreenState();
}

class _ObjectSingleScreenState extends State<ObjectSingleScreen> {
  Map<String?, dynamic> object = {};
  final List<AccessItem> accessItems = [
    AccessItem(
      title: 'Apartments',
      routeName: 'appartaments',
      imageAssets: [
        'assets/img/appartaments.png',
        'assets/img/appartaments1.png'
      ],
    ),
    AccessItem(
      title: 'Staff',
      routeName: 'staff',
      imageAssets: ['assets/img/staff.png', 'assets/img/staff1.png'],
    ),
  ];

  final Map<String, Color> serviceColors = {
    'Cleaning': const Color(0xFFECA564),
    'Trash removal': const Color(0xFFB7BE61),
    'Gardener': const Color(0xFF61BE75),
    'Pool': const Color(0xFF61B3BE),
    'Electrician': const Color(0xFFF6C52D),
    'Other': const Color(0xFF7961BE),
  };
  final List<String> services = [
    'Cleaning',
    'Trash removal',
    'Gardener',
    'Pool',
    'Electrician',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _readyObject();
  }

  Future<void> _readyObject() async {
    try {
      final response =
          await DioSingleton().dio.get('get_objects_uk/${widget.id}');
      setState(() {
        object = response.data;
      });
    } catch (e) {
      print("Ошибка при получении информации о профиле: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, bottom: 163, top: 70),
              color: const Color(0xFF18232D),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 29, top: 8),
                    child: Transform.rotate(
                      angle: math.pi / -1,
                      child: GestureDetector(
                        onTap: () {
                          context.router.pop();
                        },
                        child: Image.asset('assets/img/chevron_right.png'),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${object['object_name']}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${object['object_address']}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(0, -100),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'assets/img/object.jpg',
                          fit: BoxFit.cover,
                        )),
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    builder: (BuildContext context) {
                                      return AppartamentsModal(id: widget.id);
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
                                        return EmployStaffModal(
                                          apiUrl:
                                              'get_objects_uk/${widget.id}/get_staff_object',
                                        );
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
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'List of services',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Color(0xFFB4B7B8),
                                ))
                          ],
                        ),
                        const SizedBox(height: 15),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 10.0,
                          children: services.map((service) {
                            return Container(
                                decoration: BoxDecoration(
                                    color: serviceColors[service],
                                    borderRadius: BorderRadius.circular(15)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 17),
                                child: Text(
                                  service,
                                ));
                          }).toList(),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
