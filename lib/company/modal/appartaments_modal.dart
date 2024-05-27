import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_appartaments.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/empty_state.dart';
import 'package:path/path.dart';

class AppartamentsModal extends StatefulWidget {
  final int? id;
  final String? type;
  const AppartamentsModal({super.key, this.id, this.type});

  @override
  State<AppartamentsModal> createState() => _AppartamentsModalState();
}

class _AppartamentsModalState extends State<AppartamentsModal> {
  List<Map<String, dynamic>> apartmentsList = [];
  List<Map<String, dynamic>> filteredApartmentsList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAppartamentsList();
    _searchController.addListener(_filterApartments);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterApartments);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getAppartamentsList() async {
    try {
      Response response;
      if (widget.type == 'employee') {
        response = await DioSingleton().dio.get('employee/apartments');
      } else {
        response = await DioSingleton()
            .dio
            .get('get_objects_uk/${widget.id}/apartment_list');
      }
      if (response.data != null && response.data['apartments'] is List) {
        final List appartaments = response.data['apartments'];
        setState(() {
          apartmentsList = List<Map<String, dynamic>>.from(appartaments);
          filteredApartmentsList = apartmentsList;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("Ошибка при получении данных: $e");
    }
  }

  void _filterApartments() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredApartmentsList = apartmentsList.where((apartment) {
        final name = apartment['apartment_name']?.toLowerCase() ?? '';
        final area = apartment['area']?.toString().toLowerCase() ?? '';
        return name.contains(query) || area.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Wrap(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 10),
              child: const ModalHeader(title: 'Apartments'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(bottom: 10),
              child: UkTextField(
                controller: _searchController,
                hint: 'Search an apartments',
                suffixIcon: const Icon(Icons.search),
              ),
            ),
            Container(
              constraints: BoxConstraints(maxHeight: 400),
              child: filteredApartmentsList.isEmpty
                  ? const EmptyState(
                      title: "No apartments available",
                      text: '',
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: filteredApartmentsList.map((apartment) {
                        return AppartmentCardObjects(
                          id: apartment['id'],
                          name: apartment['apartment_name'] ?? 'No Name',
                          area: apartment['area'] ?? 'No Address',
                        );
                      }).toList(),
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: CustomBtn(
                height: 55,
                title: 'Add apartments',
                onPressed: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext modalContext) {
                      return AddAppartamentsModal(
                        id: widget.type == 'employee' ? null : widget.id,
                        type: widget.type,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppartmentCardObjects extends StatelessWidget {
  final String name;
  final dynamic area; // Changed to dynamic to handle different data types
  final int id;

  const AppartmentCardObjects({
    super.key,
    required this.name,
    required this.area,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AutoRouter.of(context).push(CompanyAppartamentsRoute(id: id));
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 19),
                  child: Image.asset('assets/img/appartaments_icon.png'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      area.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFA5A5A7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
