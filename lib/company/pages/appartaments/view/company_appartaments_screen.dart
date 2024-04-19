import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_application/company/components/add_btn.dart';
import 'package:flutter_application/company/components/card_small.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_element_default.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_issue_invoice.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_meter_modal.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_tenant_modal.dart';
import 'package:flutter_application/company/modal/ModalInfo/info_metter_modal.dart';
import 'package:flutter_application/company/modal/ModalInfo/payment/info_payment_modal.dart';
import 'package:flutter_application/company/modal/service_orders_modal.dart';
import 'package:flutter_application/service/dio_config.dart';

@RoutePage()
class CompanyAppartamentsScreen extends StatefulWidget {
  final int id;
  const CompanyAppartamentsScreen({Key? key, @PathParam('id') required this.id})
      : super(key: key);

  @override
  State<CompanyAppartamentsScreen> createState() =>
      _CompanyAppartamentsScreenState();
}

class _CompanyAppartamentsScreenState extends State<CompanyAppartamentsScreen> {
  List<Map<String, String>> bathrooms = [];

  Map<String?, dynamic> appartments = {};
  List<Map<String, bool>> itemsToAdd = [
    {"pool": true},
    {"garden": true},
  ];
  int currentIndex = 0;

  Future<void> _getAppartments() async {
    try {
      final response = await DioSingleton()
          .dio
          .get('employee/apartments/apartment_info/${widget.id}');
      setState(() {
        appartments = response.data;
      });
    } catch (e) {
      print("Ошибка при получении информации о профиле: $e");
    }
  }

  Future<void> _createBathroom(String characteristic) async {
    try {
      final postData = {
        'characteristic': characteristic,
      };

      final response = await DioSingleton().dio.post(
            'employee/apartments/apartment_info/${widget.id}/add_bathroom',
            data: postData,
          );

      setState(() {
        bathrooms.add({
          'id': response.data['id'].toString(),
          'characteristic': characteristic,
        });
      });
    } catch (e) {
      print("Исключение при добавлении ванной комнаты: $e");
    }
  }

  Future<void> _addAdditionallyItem(
      {required Map<String, bool> additional}) async {
    try {
      final postData = additional;

      final response = await DioSingleton().dio.post(
            'employee/apartments/apartment_info/${widget.id}/add_additionally',
            data: postData,
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Дополнительный элемент успешно добавлен');
        // Опционально: обновите UI или состояние приложения здесь
      } else {
        print(
            'Ошибка при добавлении дополнительного элемента: ${response.statusCode}');
      }
    } catch (e) {
      print("Исключение при добавлении дополнительного элемента: $e");
    }
  }

  void _addNextItem() {
    if (currentIndex < itemsToAdd.length) {
      _addAdditionallyItem(additional: itemsToAdd[currentIndex]);
      currentIndex++;
    } else {
      print("Все элементы добавлены");
      // Опционально: сбросить currentIndex, если нужно начать заново
      // currentIndex = 0;
    }
  }

  // Future<void> _removeBathroom(int index) async {
  //   String bathroomId = bathrooms[index];

  //   try {
  //     final response = await DioSingleton().dio.delete(
  //           'employee/apartments/apartment_info/${widget.id}/remove_bathroom/$bathroomId',
  //         );

  //     if (response.statusCode == 200) {
  //       setState(() {
  //         bathrooms.removeAt(index);
  //       });
  //     } else {
  //       print('Ошибка при удалении ванной комнаты: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print("Исключение при удалении ванной комнаты: $e");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _getAppartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 16, top: 70),
          color: const Color(0xFF18232D),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 29, top: 8),
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
                          appartments['apartment_name']?.toString() ?? '',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          appartments['area']?.toString() ?? '',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/img/object.jpg',
                      fit: BoxFit.cover,
                    )),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AddBtn(
                    title: 'Add  \na tenant',
                    mode: AddBtnMode.dark,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        builder: (BuildContext context) {
                          return AddTenantModal(id: widget.id);
                        },
                      );
                    },
                  ),
                  AddBtn(
                      title: 'Issue \nan invoice',
                      mode: AddBtnMode.dark,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          builder: (BuildContext context) {
                            return AddIssueInvoice(id: widget.id);
                          },
                        );
                      }),
                  AddBtn(
                      title: 'Enter meter \nreadings',
                      mode: AddBtnMode.dark,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          builder: (BuildContext context) {
                            return AddMeterModal(id: widget.id);
                          },
                        );
                      }),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.only(top: 15, bottom: 32, left: 15, right: 15),
          child: Wrap(
            runSpacing: 7,
            spacing: 7,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CardSmall(
                  name: 'Service \norders',
                  img: 'order',
                  gradient: CardGradient.first,
                  modal: ServiceOrdersModal(id: widget.id)),
              CardSmall(
                  name: 'Meter readings',
                  img: 'meters_readings',
                  gradient: CardGradient.second,
                  modal: InfoMetterModal(id: widget.id)),
              CardSmall(
                  name: 'Payment history',
                  img: 'payment',
                  gradient: CardGradient.third,
                  modal: InfoMetterModal(id: widget.id)),
            ],
            // modal: InfoPaymentModal(id: widget.id)),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bathrooms',
                style: TextStyle(
                    color: Color(0xFF73797C), fontWeight: FontWeight.w500),
              ),
              IconButton(
                color: const Color(0xFFB4B7B8),
                iconSize: 18,
                icon: const Icon(Icons.add),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    builder: (BuildContext context) {
                      return AddElementDefault(
                        onAdd: _createBathroom,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bathrooms.length,
          itemBuilder: (context, index) {
            return BathRooms(
              bathroom: bathrooms[index],
              index: index,
            );
          },
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          margin: const EdgeInsets.only(bottom: 12),
          child: const Text(
            'Internet',
            style: TextStyle(
                color: Color(0xFF73797C), fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          margin: const EdgeInsets.only(bottom: 15),
          child: Container(
            height: 53,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Operator, speed',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${appartments['internet_operator']?.toString()} / ${appartments['internet_speed']?.toString()} / ${appartments['internet_fee']?.toString()}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Additionally',
                style: TextStyle(
                    color: Color(0xFF73797C), fontWeight: FontWeight.w500),
              ),
              IconButton(
                  color: const Color(0xFFB4B7B8),
                  iconSize: 18,
                  icon: const Icon(Icons.add),
                  onPressed: _addNextItem),
            ],
          ),
        ),
      ]),
    );
  }
}

class BathRooms extends StatefulWidget {
  final int index;
  final Map<String, String> bathroom;
  // final Function(int index) onRemove;

  const BathRooms({
    super.key,
    required this.index,
    // required this.onRemove,
    required this.bathroom,
  });

  @override
  State<BathRooms> createState() => _BathRoomsState();
}

class _BathRoomsState extends State<BathRooms> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 53,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              '${widget.index + 1}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Container(
              height: 53,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Flexible(
                  child: Text(widget.bathroom['characteristic'] ??
                      'Characteristic not specified'),
                ),
                // IconButton(
                //   color: const Color(0xFFB4B7B8),
                //   iconSize: 17,
                //   icon: const Icon(Icons.close),
                //   onPressed: () {
                //     showDialog<void>(
                //       context: context,
                //       builder: (BuildContext dialogContext) {
                //         return AlertDialog(
                //           title: const Text('Confirm'),
                //           content: const Text(
                //               'Are you sure you want to delete this item?'),
                //           actions: <Widget>[
                //             TextButton(
                //               child: const Text('Cancel'),
                //               onPressed: () {
                //                 Navigator.of(dialogContext).pop();
                //               },
                //             ),
                //             TextButton(
                //               child: const Text('Delete'),
                //               onPressed: () {
                //                 widget.onRemove(widget.index);
                //                 Navigator.of(dialogContext).pop();
                //               },
                //             ),
                //           ],
                //         );
                //       },
                //     );
                //   },
                // ),
              ]),
            ),
          )
        ],
      ),
    );
  }
}

class AddiotionalItem extends StatelessWidget {
  final String name;
  const AddiotionalItem({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(name),
    );
  }
}
