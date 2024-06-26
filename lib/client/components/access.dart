import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/router/router.dart';

class Access extends StatefulWidget {
  const Access({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AccessState createState() => _AccessState();
}

class _AccessState extends State<Access> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Quick access',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              // TextButton(
              //   onPressed: () {},
              //   child: const Text(
              //     'Set up',
              //     style: TextStyle(fontWeight: FontWeight.w500),
              //   ),
              //   style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
              // )
            ],
          ),
        ),
        ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(70, 78, 146, 1),
                            Color.fromRGBO(149, 155, 206, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(
                              left: 16, top: 25, bottom: 16, right: 29),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          AutoRouter.of(context).push(const InquiresRoute());
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Maintenance',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image.asset('assets/img/maintenance.png'),
                                Image.asset('assets/img/maintenance1.png'),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(12, 24, 34, 1),
                            Color.fromRGBO(31, 56, 99, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(
                              left: 16, top: 25, bottom: 16, right: 29),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          AutoRouter.of(context).push(const DevelopmentRoute());
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Guest pass',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image.asset('assets/img/pass.png'),
                                Image.asset('assets/img/pass1.png'),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(23, 32, 43, 1),
                            Color.fromRGBO(58, 71, 82, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(
                              left: 16, top: 25, bottom: 16, right: 29),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          AutoRouter.of(context).push(const MettersRoute());
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Meters',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image.asset('assets/img/meters.png'),
                                Image.asset('assets/img/meters1.png'),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(22, 33, 43, 1),
                            Color.fromRGBO(65, 74, 83, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(
                              left: 16, top: 25, bottom: 16, right: 29),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          AutoRouter.of(context).push(const FinancesRoute());
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Finances',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image.asset('assets/img/finance.png'),
                                Image.asset('assets/img/finance1.png'),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
