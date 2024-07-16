import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/modal/appartaments_modal.dart';
import 'package:flutter_application/company/modal/employ_staff_modal.dart';
import 'package:flutter_application/components/access/access_item.dart';
import 'package:flutter_application/components/bottom_admin_bar.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'dart:math' as math;

class ObjectService {
  ObjectService({
    required this.id,
    required this.serviceName,
  });

  final int id;
  final String serviceName;

  factory ObjectService.fromJson(Map<String, dynamic> json) {
    return ObjectService(
      id: json['id'],
      serviceName: json['service_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_name': serviceName,
    };
  }
}

@RoutePage()
class ObjectSingleScreen extends StatefulWidget {
  final int id;
  const ObjectSingleScreen({Key? key, @PathParam('id') required this.id})
      : super(key: key);

  @override
  State<ObjectSingleScreen> createState() => _ObjectSingleScreenState();
}

class _ObjectSingleScreenState extends State<ObjectSingleScreen> {
  List<ObjectService> servicesSelecteds = [];
  List<ObjectService> availableServices = [];
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

  @override
  void initState() {
    super.initState();
    _readyObject();
    _getServices();
  }

  Future<void> _readyObject() async {
    try {
      final response =
          await DioSingleton().dio.get('get_objects_uk/${widget.id}');
      setState(() {
        object = response.data;
        if (object['list_services'] != null) {
          servicesSelecteds = List<ObjectService>.from(
            object['list_services']
                .map((service) => ObjectService.fromJson(service)),
          );
        }
      });
    } catch (e) {
      print("Ошибка при получении информации о профиле: $e");
    }
  }

  Future<void> _getServices() async {
    try {
      final response = await DioSingleton()
          .dio
          .get('get_objects_uk/${widget.id}/list-service');
      setState(() {
        availableServices = List<ObjectService>.from(
          response.data.map((service) => ObjectService.fromJson(service)),
        );
      });
    } catch (e) {
      print("Ошибка при получении списка услуг: $e");
    }
  }

  Future<void> addServiceItem() async {
    try {
      // Найти первую услугу из availableServices, которой нет в object['list_services']
      ObjectService? newService;

      for (var service in availableServices) {
        bool serviceExistsInObject = object['list_services'] != null &&
            object['list_services'].any((s) => s['id'] == service.id);

        if (!serviceExistsInObject) {
          newService = service;
          break;
        }
      }

      if (newService == null) {
        print("Нет новых услуг для добавления");
        return;
      }

      await DioSingleton().dio.post(
            'get_objects_uk/${widget.id}/list-service',
            data: newService.toJson(),
          );

      setState(() {
        if (object['list_services'] != null) {
          object['list_services'].add(newService!.toJson());
        } else {
          object['list_services'] = [newService!.toJson()];
        }
        servicesSelecteds.add(newService!);
      });
    } catch (e) {
      print("Ошибка при добавлении услуги: $e");
    }
  }

  Future<void> removeServiceItem(int id) async {
    try {
      await DioSingleton()
          .dio
          .delete('get_objects_uk/${widget.id}/list-service/$id/delete');
      setState(() {
        // Удаляем услугу из object['list_services']
        if (object['list_services'] != null) {
          object['list_services'].removeWhere((service) => service['id'] == id);
        }
        servicesSelecteds.removeWhere((service) => service.id == id);
      });
    } catch (e) {
      print("Ошибка при удалении услуги: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.only(
                left: 15, right: 15, bottom: 163, top: 40),
            color: const Color(0xFF18232D),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 29, top: 8),
                  child: Transform.rotate(
                    angle: math.pi / -1,
                    child: InkWell(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
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
                    if (object['object_name'] != null)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6,
                        ),
                        child: Text(
                          object['object_name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                    if (object['object_address'] != null)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6,
                        ),
                        child: Text(
                          object['object_address'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -100),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                if (object['main_photo_path'] != null)
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        object['main_photo_path'] ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 15, right: 15, bottom: 20),
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
                            onPressed: () {
                              addServiceItem();
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 20,
                              color: Color(0xFFB4B7B8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      if (object['list_services'] != null &&
                          object['list_services'].isNotEmpty)
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 10.0,
                          children:
                              object['list_services'].map<Widget>((service) {
                            return Container(
                              decoration: BoxDecoration(
                                color: serviceColors[service['service_name']] ??
                                    Colors.grey,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 17),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    service['service_name'] ?? '',
                                    style: const TextStyle(color: Colors.white),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      removeServiceItem(service['id']);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAdminBar(),
    );
  }
}
