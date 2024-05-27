import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/pages/articles/view/view.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/empty_state.dart';

class News extends StatefulWidget {
  final String? type;
  const News({super.key, this.type});

  @override
  State<News> createState() => _NewsState();
}

class NewsItem {
  final int id;
  final String? date;
  // ignore: non_constant_identifier_names
  final String? created_at;
  final String? description;
  final String? name;
  final String? img;

  NewsItem({
    required this.id,
    this.date,
    // ignore: non_constant_identifier_names
    this.created_at,
    this.description,
    this.name,
    this.img,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'],
      date: json['date']?.toString(),
      img: json['photo_path']?.toString(),
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
      final response = await DioSingleton().dio.get('${widget.type}/all-news');
      final data = List<Map<String, dynamic>>.from(response.data);
      setState(() {
        newsList = data.map((item) => NewsItem.fromJson(item)).toList();
      });
      // print("Получение новостей: $newsList");
    } catch (e) {
      // ignore: avoid_print
      // print("Ошибка при получении новостей: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'News',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            if (!newsList.isEmpty)
              TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return ArticlesScreen(type: widget.type!);
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 11),
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
        Container(
          child: newsList.isEmpty
              ? EmptyState(title: 'Empty news', text: '')
              : Container(
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
                          margin: const EdgeInsets.only(right: 20),
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
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              AutoRouter.of(context).push(NewsRoute(
                                  id: newsItem.id, type: widget.type));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 14, right: 16, bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    newsItem.name.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 40),
                                  Text(
                                    newsItem.created_at.toString(),
                                    style: const TextStyle(
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
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
