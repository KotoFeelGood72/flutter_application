import 'package:flutter/material.dart';

class ClientNoteScreen extends StatefulWidget {
  const ClientNoteScreen({super.key});

  @override
  State<ClientNoteScreen> createState() => _ClientNoteScreenState();
}

class _ClientNoteScreenState extends State<ClientNoteScreen> {
  final List<Map<String, dynamic>> notes = [
    {
      "title": "Срочное уведомление",
      "date": "2024-05-01",
      "description": "Необходимо обновить данные.",
      "viewed": false
    },
    {
      "title": "Плановая проверка",
      "date": "2024-05-02",
      "description": "Запланирована проверка системы.",
      "viewed": true
    },
    {
      "title": "Собрание",
      "date": "2024-05-03",
      "description": "Общее собрание в 15:00.",
      "viewed": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Container(
            child: const Text(
              'Notification',
            ),
          )),
      body: Container(
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            var note = notes[index];
            return NoteItems(
              title: note['title']!,
              date: note['date']!,
              description: note['description']!,
              viewed: note['viewed'],
              isLastItem: index ==
                  notes.length - 1, // Проверяем, последний ли это элемент
            );
          },
        ),
      ),
    );
  }
}

class NoteItems extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final bool viewed;
  final bool isLastItem;

  const NoteItems({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.viewed,
    required this.isLastItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        border: isLastItem
            ? null
            : Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Image.asset('assets/img/notification.png', width: 40)),
              if (!viewed)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFA5A5A7),
                  ),
                ),
                SizedBox(height: 8),
                Text(description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
