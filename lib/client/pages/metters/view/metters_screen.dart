import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/client/modal/client_modal_meter.dart';
import 'package:flutter_application/components/ui/page_header.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/empty_state.dart';

class MetterItem {
  final int id;
  final String iconPath;
  final String name;

  MetterItem({required this.id, required this.iconPath, required this.name});

  factory MetterItem.fromJson(Map<String, dynamic> json) {
    return MetterItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      iconPath: json['icon_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon_path': iconPath,
      'name': name,
    };
  }
}

@RoutePage()
class MettersScreen extends StatefulWidget {
  const MettersScreen({super.key});

  @override
  State<MettersScreen> createState() => _MettersScreenState();
}

class _MettersScreenState extends State<MettersScreen> {
  List<MetterItem> meters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getClientMetters();
  }

  Future<void> _getClientMetters() async {
    try {
      final response = await DioSingleton().dio.get('client/meters');
      final List<dynamic> data = response.data;
      setState(() {
        meters = data.map((json) => MetterItem.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(title: 'Meters'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : meters.isEmpty
              ? EmptyState(title: 'No meters available', text: '')
              : ListView.builder(
                  itemCount: meters.length,
                  itemBuilder: (context, index) {
                    final meter = meters[index];
                    return Column(
                      children: [
                        ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: meter.iconPath.isNotEmpty
                                ? Image.network(
                                    meter.iconPath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/img/electrity.png');
                                    },
                                  )
                                : Image.asset('assets/img/electrity.png'),
                          ),
                          title: Text(meter.name),
                          subtitle: Text('Meter ID: ${meter.id}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return ClientModalMeter(
                                  id: meter.id,
                                );
                              },
                            );
                          },
                        ),
                        Divider(
                          color: Colors.grey[300],
                          height: 1,
                          thickness: 1,
                          indent: 72, // Align with leading icon
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
