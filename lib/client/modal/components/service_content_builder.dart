import 'package:flutter/material.dart';
import 'package:flutter_application/client/modal/components/service_item.dart'; // Убедитесь, что путь правильный

// Предполагая, что ServiceItem и servicesList уже определены в вашем коде
void onServiceItemSelected(
    bool isSelected, String serviceName, double price, int quantity) {
  // Логика обновления состояния на основе выбранных услуг
  // Например, добавление или удаление услуги из списка
}
Widget buildServiceContent(String? service, List<ServiceItem> servicesList,
    void Function(bool, String, double, int) updateActiveServices) {
  switch (service) {
    case 'Cleaning':
    case 'Gardener':
    case 'Pool':
      // Используем ListView.builder для динамического создания списка услуг
      return ListView.builder(
        shrinkWrap: true,
        itemCount: servicesList.length,
        itemBuilder: (context, index) {
          final item = servicesList[index];
          return ServiceItem(
            serviceName: item.serviceName,
            price: item.price,
            isCountable: item.isCountable,
            onSelected: (bool isSelected, String serviceName, double price,
                int quantity) {
              updateActiveServices(isSelected, serviceName, price, quantity);
            },
          );
        },
      );

    case 'Trash removal':
    case 'Other':
      // Код для других услуг остаётся без изменений
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              maxLines: 6,
              style: const TextStyle(
                fontSize: 14.0,
              ),
              decoration: InputDecoration(
                hintText: "Describe the required service",
                fillColor: const Color(0xFFF5F5F5),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 17),
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'no more than 500 characters',
                // ignore: use_full_hex_values_for_flutter_colors
                style: TextStyle(fontSize: 12, color: Color(0xff73797c80)),
              ),
            ),
          )
        ],
      );
    default:
      // Если услуга не выбрана, отображаем пустой контейнер или информационное сообщение
      return const Center(
        child: Text('Please select a service to see more options'),
      );
  }
}
