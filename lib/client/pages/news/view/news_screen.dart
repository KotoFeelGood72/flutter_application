import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/components/ui/page_header.dart';
import 'package:flutter_application/service/dio_config.dart';

class NewsId {
  NewsId({
    required this.title,
    required this.img,
    required this.description,
    required this.created_at,
  });

  final String? title;
  final String? img;
  final String? description;
  final String? created_at;

  factory NewsId.fromJson(Map<String, dynamic> json) {
    return NewsId(
      title: json['name'],
      img: json['photo_path'],
      description: json['description'],
      created_at: json['created_at'],
    );
  }
}

@RoutePage()
class NewsScreen extends StatefulWidget {
  final String? type;
  final int id;
  const NewsScreen({Key? key, required this.id, this.type}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  NewsId? news;
  @override
  void initState() {
    super.initState();
    _getNewsId();
  }

  Future<void> _getNewsId() async {
    try {
      final response =
          await DioSingleton().dio.get('${widget.type}/all-news/${widget.id}');
      setState(() {
        news = NewsId.fromJson(response.data);
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(
        title: 'News',
      ),
      body: news == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  (news!.img != null && news!.img!.isNotEmpty)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(news!.img!, fit: BoxFit.cover),
                        )
                      : const SizedBox.shrink(),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news!.title ?? 'No title',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          news!.created_at ?? 'No date',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          news!.description ?? 'No description available.',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
