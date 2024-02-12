import 'package:flutter/material.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class NewsItem {
  final String text;
  final String date;
  final String navigatorLink;

  NewsItem(
      {required this.text, required this.date, required this.navigatorLink});
}

class _NewsState extends State<News> {
  final List<NewsItem> newsList = [
    NewsItem(
        text: "Updating pedestrian paths",
        date: "July 21, 2023",
        navigatorLink: "/news1"),
    NewsItem(
        text: "Comfort service report for the 2nd quarter of 2023",
        date: "July 21, 2023",
        navigatorLink: "/news2"),
    // Добавьте здесь больше новостей
  ];
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
            // SizedBox(height: 9),
            SizedBox(
              height: 145,
              // Оберните ListView.builder в Expanded
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal, // Горизонтальная прокрутка
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  // Получение новости из списка
                  NewsItem newsItem = newsList[index];

                  // Создание виджета для каждой новости
                  return Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white, // background: #FFF;
                        borderRadius:
                            BorderRadius.circular(15), // border-radius: 15px;
                        boxShadow: const [
                          BoxShadow(
                            color:
                                Color.fromRGBO(200, 199, 199, 0.5), // Цвет тени
                            blurRadius: 10, // Размытие тени
                            offset: Offset(1, 1), // Смещение тени по X и Y
                          ),
                        ],
                      ),
                      width: 239, // Явно укажите ширину для каждого элемента
                      child: InkWell(
                        onTap: () {
                          // Действие при нажатии на новость, например, навигация
                          Navigator.pushNamed(context, newsItem.navigatorLink);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 14, right: 16, bottom: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                newsItem.text,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                  height:
                                      40), // Вставленный SizedBox для пространства
                              Text(
                                newsItem.date,
                                style: TextStyle(
                                    color: Color(0xBC9FA0A2), fontSize: 12),
                              ),
                              // Другие виджеты, если нужны
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
