import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_object_modal.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/default_list_card.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';

class EmployObjectModal extends StatefulWidget {
  const EmployObjectModal({super.key});

  @override
  State<EmployObjectModal> createState() => _EmployObjectModalState();
}

class _EmployObjectModalState extends State<EmployObjectModal> {
  List<Map<String, dynamic>> objectList = [];

  @override
  void initState() {
    super.initState();
    _getObjectList();
  }

  Future<void> _getObjectList() async {
    try {
      final response = await DioSingleton().dio.get('get_objects_uk');
      if (response.data != null && response.data['objects'] is List) {
        final List objects = response.data['objects'];
        setState(() {
          objectList = List<Map<String, dynamic>>.from(objects);
        });
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 24),
      child: Column(
        children: [
          const ModalHeader(title: 'Objects'),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: objectList.map((object) {
                return DefaultListCard(
                  id: object['id'],
                  name: object['object_name'] ?? 'No Name',
                  address: object['object_address'] ?? 'No Address',
                  imageUrl: 'assets/img/house.png',
                  route: ObjectSingleRoute(id: object['id']),
                );
              }).toList(),
            ),
          ),
          CustomBtn(
              title: 'Add an object',
              onPressed: () {
                Navigator.pop(context);
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
              })
        ],
      ),
    );
  }
}
