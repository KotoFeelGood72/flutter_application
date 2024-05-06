import 'package:flutter/material.dart';
import 'package:flutter_application/service/dio_config.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class NewsItem {
  final String? id;
  final String? date;
  final String? created_at;
  final String? description;
  final String? name;

  NewsItem({
    this.id,
    this.date,
    this.created_at,
    this.description,
    this.name,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id']?.toString(),
      date: json['date']?.toString(),
      created_at: json['created_at']?.toString(),
      description: json['description'],
      name: json['name'],
    );
  }
}

class _NewsState extends State<News> {
  List<NewsItem> newsList = [];

  @override
  void initState() {
    super.initState();
    _getHomeNews();
  }

  Future<void> _getHomeNews() async {
    try {
      final response = await DioSingleton().dio.get('client/news');
      final data = List<Map<String, dynamic>>.from(response.data);
      setState(() {
        newsList = data.map((item) => NewsItem.fromJson(item)).toList();
      });
      // print("Получение новостей: $newsList");
    } catch (e) {
      print("Ошибка при получении новостей: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'News',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 11),
                          child: const Text(
                            'All',
                            style: TextStyle(color: Color(0xFFA9A9AB)),
                          ),
                        ),
                        Image.asset('assets/img/arrow-right.png')
                      ],
                    ))
              ],
            ),
            SizedBox(
              height: 145,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  NewsItem newsItem = newsList[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(200, 199, 199, 0.5),
                            blurRadius: 10,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      width: 239,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, newsItem.id.toString());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 14, right: 16, bottom: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                newsItem.name.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 40),
                              Text(
                                newsItem.created_at.toString(),
                                style: TextStyle(
                                    color: Color(0xBC9FA0A2), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
