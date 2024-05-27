import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/client/components/news.dart';
import 'package:flutter_application/components/bottom_admin_bar.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';

@RoutePage()
class ArticlesScreen extends StatefulWidget {
  final String type;
  const ArticlesScreen({super.key, required this.type});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  List<NewsItem> newsList = [];

  Future<void> _getNews() async {
    try {
      final response = await DioSingleton().dio.get('${widget.type}/all-news');
      final data = List<Map<String, dynamic>>.from(response.data);
      setState(() {
        newsList = data.map((item) => NewsItem.fromJson(item)).toList();
      });
    } catch (e) {
      // print("Ошибка при получении новостей: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(13.0),
            child: InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () {
                context.router.pop();
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 14,
                  ),
                ),
              ),
            ),
          ),
          title: const Text('News',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          itemCount: newsList.length,
          itemBuilder: (context, index) {
            final newsItem = newsList[index];
            return Column(
              children: [
                Stack(
                  children: [
                    ListTile(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      title: Text(newsItem.name!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(newsItem.created_at!,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            newsItem.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      onTap: () {
                        AutoRouter.of(context).push(
                            NewsRoute(id: newsItem.id, type: widget.type));
                      },
                    ),
                    const Positioned(
                      right: 0,
                      top: 10,
                      child: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                if (index < newsList.length - 1) const Divider(thickness: 0.4),
              ],
            );
          },
        ),
        bottomNavigationBar: const BottomAdminBar(),
      ),
    );
  }
}
