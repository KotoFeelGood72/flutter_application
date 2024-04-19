import 'package:flutter/material.dart';

class SelectObjects extends StatefulWidget {
  const SelectObjects({super.key});

  @override
  State<SelectObjects> createState() => _SelectObjectsState();
}

class _SelectObjectsState extends State<SelectObjects> {
  bool _isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 22, bottom: 20, right: 19, left: 19),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Object selection',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(100)),
                    width: 24,
                    height: 24,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        size: 15,
                        color: Color(0xFFB4B7B8),
                      ),
                    )),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 34, bottom: 25),
              decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8)),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Smart, 17 12-2 floor 2, room 23',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: const Text(
                'Desired completion date',
                style: TextStyle(
                    color: Color(0xFF73797C), fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, bottom: 10, right: 20),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ExpansionTile(
                      initiallyExpanded: true,
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(style: BorderStyle.none),
                      ),
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          _isExpanded = expanded;
                        });
                      },
                      title: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: const Icon(Icons.trip_origin_outlined,
                                      size: 20.0),
                                ),
                              ),
                              const Text('SMART 17',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFE0E0E0),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: ObjectTile(
                            title: 'Smart, 17 12-2 floor 2, room 23',
                            subtitle: 'AS: 1486',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ObjectTile extends StatelessWidget {
  const ObjectTile({super.key, required this.title, required this.subtitle});
  // Props
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 27, top: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(color: Color(0xFF878E92), fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
