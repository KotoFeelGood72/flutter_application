import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_tenant_modal.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/models/tenant_models.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/empty_state.dart';

class ListTenantModal extends StatefulWidget {
  final int id;
  const ListTenantModal({super.key, required this.id});

  @override
  State<ListTenantModal> createState() => _ListTenantModalState();
}

class _ListTenantModalState extends State<ListTenantModal> {
  TenantModels? tenantModels;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getListTenant();
  }

  Future<void> _getListTenant() async {
    try {
      final response = await DioSingleton()
          .dio
          .get('employee/apartments/apartment_info/${widget.id}/list_tenant');
      tenantModels = TenantModels.fromJson(response.data);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Ошибка при получении данных: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: const ModalHeader(title: 'Tenants')),
        Container(
          constraints: const BoxConstraints(maxHeight: 400),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : tenantModels == null || tenantModels!.tenants.isEmpty
                  ? const EmptyState(
                      title: "No tenants available",
                      text: '',
                    )
                  : ListView.builder(
                      itemCount: tenantModels!.tenants.length,
                      itemBuilder: (context, index) {
                        return TenantCard(
                          id: widget.id,
                          tenant: tenantModels!.tenants[index],
                          showBorder: index != tenantModels!.tenants.length - 1,
                        );
                      },
                    ),
        ),
        Container(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: CustomBtn(
              title: 'Add a tenant',
              onPressed: () {
                Navigator.of(context).pop();
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
            )),
      ],
    );
  }
}

class TenantCard extends StatelessWidget {
  final Tenant tenant;
  final bool showBorder;
  final int id;

  const TenantCard({
    super.key,
    required this.tenant,
    required this.showBorder,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AutoRouter.of(context)
          .push(TenantProfileRoute(id: tenant.id, apartmentsId: id)),
      child: Container(
        decoration: BoxDecoration(
          border: showBorder
              ? const Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                )
              : null,
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundImage: tenant.photoPath.isNotEmpty
                  ? NetworkImage(tenant.photoPath)
                  : null,
              radius: 25,
              child: tenant.photoPath.isEmpty
                  ? const Icon(Icons.person, size: 30)
                  : null,
            ),
            title: Text(
              '${tenant.firstname} ${tenant.lastname}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tenant.email,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFFA5A5A7)),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tenant.phoneNumber,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFFA5A5A7)),
                    ),
                    Text(
                      'Balance: \$${tenant.balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFFA5A5A7)),
                    ),
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}
