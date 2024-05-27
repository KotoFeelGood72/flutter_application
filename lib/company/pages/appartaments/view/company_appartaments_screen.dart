import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/bloc/company_bloc.dart';
import 'dart:math' as math;

import 'package:flutter_application/company/components/add_btn.dart';
import 'package:flutter_application/company/components/card_small.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_element_default.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_issue_invoice.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_meter_modal.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_tenant_modal.dart';
import 'package:flutter_application/company/modal/ModalInfo/info_metter_modal.dart';
import 'package:flutter_application/company/modal/ModalInfo/list_tenant_modal.dart';
import 'package:flutter_application/company/modal/ModalInfo/payment/info_payment_modal.dart';
import 'package:flutter_application/company/modal/service_orders_modal.dart';
import 'package:flutter_application/components/bottom_admin_bar.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/models/ApartmentId.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CompanyAppartamentsScreen extends StatefulWidget {
  final int id;
  CompanyAppartamentsScreen({Key? key, @PathParam('id') required this.id})
      : super(key: key);

  @override
  State<CompanyAppartamentsScreen> createState() =>
      _CompanyAppartamentsScreenState();
}

class _CompanyAppartamentsScreenState extends State<CompanyAppartamentsScreen> {
  ApartmentId? apartmentId;
  // final _companyBloc = CompanyBloc();
  late CompanyBloc _companyBloc;
  List<Map<String, String>> bathrooms = [];
  bool toggle = true;
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
        if (response.data['bathrooms'] != null) {
          bathrooms = List<Map<String, String>>.from(
            response.data['bathrooms'].map(
              (bathroom) => {
                'id': bathroom['id'].toString(),
                'characteristic': bathroom['characteristic'].toString(),
              },
            ),
          );
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print("Ошибка при получении информации о профиле: $e");
    }
  }

  bool allItemsAdded() {
    for (var item in itemsToAdd) {
      String key = item.keys.first;
      if (appartments[key] != true) {
        return false;
      }
    }
    return true;
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
      // ignore: avoid_print
      print("Исключение при добавлении ванной комнаты: $e");
    }
  }

  Future<void> _addAdditionallyItem(
      {required Map<String, bool> additional}) async {
    try {
      final response = await DioSingleton().dio.post(
            'employee/apartments/apartment_info/${widget.id}/add_additionally',
            data: additional,
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Дополнительный элемент успешно добавлен: $additional');
        setState(() {
          appartments[additional.keys.first] = true;
        });
      }
    } catch (e) {
      print("Ошибка при добавлении дополнительного элемента: $e");
    }
  }

  void _addNextItem() {
    while (currentIndex < itemsToAdd.length) {
      Map<String, bool> currentItem = itemsToAdd[currentIndex];
      String key = currentItem.keys.first;
      bool isAdded = appartments[key] ?? false;

      if (!isAdded) {
        _addAdditionallyItem(additional: {key: true});
        break; // Прерываем цикл после успешного добавления
      }

      currentIndex = (currentIndex + 1) % itemsToAdd.length;
    }
  }

  Future<void> _removeBathroom(int index) async {
    String bathroomId = bathrooms[index]['id'] ?? '';

    try {
      final response = await DioSingleton().dio.delete(
            'employee/apartments/apartment_info/${widget.id}/add_bathroom/$bathroomId',
          );

      if (response.statusCode == 200) {
        setState(() {
          bathrooms.removeAt(index);
        });
      } else {
        // ignore: avoid_print
        print('Ошибка при удалении ванной комнаты: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print("Исключение при удалении ванной комнаты: $e");
    }
  }

  Widget _buildAdditionalItems() {
    List<Widget> listItems = [];

    if (appartments['garden'] == true) {
      listItems.add(_buildItem("Garden", () {
        _removeAdditionalFeature('garden');
      }));
    }
    if (appartments['pool'] == true) {
      listItems.add(_buildItem("Pool", () {
        _removeAdditionalFeature('pool');
      }));
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: listItems,
    );
  }

  void _removeAdditionalFeature(String feature) {
    setState(() {
      appartments[feature] = false;
    });

    DioSingleton().dio.post(
      'employee/apartments/apartment_info/${widget.id}/add_additionally',
      data: {feature: false},
    );
  }

  Widget _buildItem(String name, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 19),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFF5F5F5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 10),
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: onRemove,
              child:
                  const Icon(Icons.close, size: 16, color: Color(0xFFB4B7B8)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getAppartments();
    _companyBloc = BlocProvider.of<CompanyBloc>(context, listen: false);
    _companyBloc.add(AppartamentsLoaded(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyBloc, CompanyState>(
      bloc: _companyBloc,
      builder: (context, state) {
        if (state is CompanyInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CompanyStateData) {
          apartmentId = state.apartment;
        }
        return Scaffold(
          body: apartmentId == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(shrinkWrap: true, children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 16, top: 40),
                    color: const Color(0xFF18232D),
                    child: Column(
                      children: [
                        Row(
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
                                  child: Image.asset(
                                      'assets/img/chevron_right.png'),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  apartmentId!.apartmentName.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  apartmentId!.area.toString(),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                        if (apartmentId!.photoPath != null)
                          Container(
                            padding: const EdgeInsets.all(15),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  apartmentId!.photoPath.toString(),
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
                                    isScrollControlled: true,
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
                                    isScrollControlled: true,
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
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 10, left: 15, right: 15),
                    child: Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CardSmall(
                                  name: 'Service \norders',
                                  img: 'order',
                                  gradient: CardGradient.first,
                                  badgeContent:
                                      apartmentId!.activeOrderCount ?? null,
                                  modal: ServiceOrdersModal(id: widget.id)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CardSmall(
                                  name: 'Meter readings',
                                  img: 'meters_readings',
                                  gradient: CardGradient.second,
                                  modal: InfoMetterModal(id: widget.id)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CardSmall(
                                  name: 'Payment history',
                                  img: 'payment',
                                  gradient: CardGradient.third,
                                  modal: InfoPaymentModal(id: widget.id)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CardSmall(
                                  name: 'List \nof clients',
                                  img: 'mini-staff',
                                  gradient: CardGradient.third,
                                  modal: ListTenantModal(id: widget.id)),
                            ),
                          ],
                        ),
                      ],
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
                              color: Color(0xFF73797C),
                              fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          color: const Color(0xFFB4B7B8),
                          iconSize: 18,
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
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
                        onRemove: _removeBathroom,
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
                          color: Color(0xFF73797C),
                          fontWeight: FontWeight.w500),
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
                          const Text(
                            'Operator, speed',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${apartmentId!.internetOperator} / ${apartmentId!.internetSpeed} / ${apartmentId!.internetSpeed}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
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
                              color: Color(0xFF73797C),
                              fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          color: const Color(0xFFB4B7B8),
                          iconSize: 18,
                          icon: allItemsAdded()
                              ? const Icon(Icons.remove)
                              : const Icon(Icons.add),
                          onPressed: allItemsAdded() ? null : _addNextItem,
                        )
                      ],
                    ),
                  ),
                  ListView(shrinkWrap: true, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: _buildAdditionalItems(),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: const Text(
                      'Who keeps the keys',
                      style: TextStyle(
                          color: Color(0xFF73797C),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      height: 53,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        apartmentId!.keyHolder.toString() ?? 'No keys',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ]),
          bottomNavigationBar: BottomAdminBar(),
        );
      },
    );
  }
}

class BathRooms extends StatefulWidget {
  final int index;
  final Map<String, String> bathroom;
  final Function(int index) onRemove;

  const BathRooms({
    super.key,
    required this.index,
    required this.onRemove,
    required this.bathroom,
  });

  @override
  State<BathRooms> createState() => _BathRoomsState();
}

class _BathRoomsState extends State<BathRooms> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              borderRadius: BorderRadius.circular(10),
            ),
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
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.bathroom['characteristic'] ??
                        'Characteristic not specified',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: const Text('Confirmation'),
                            content: const Text(
                                'Are you sure you want to delete this characteristic?'),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: CustomBtn(
                                        title: 'Cancel',
                                        height: 45,
                                        color: Colors.green,
                                        borderRadius: 5,
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        }),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: CustomBtn(
                                        title: 'Delete',
                                        height: 45,
                                        borderRadius: 5,
                                        color: Colors.red,
                                        onPressed: () {
                                          if (mounted) {
                                            widget.onRemove(widget.index);
                                            Navigator.of(dialogContext).pop();
                                          }
                                        }),
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.close,
                      color: Color.fromARGB(255, 167, 167, 167),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
