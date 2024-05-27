import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_application/router/router.dart";

class Requests extends StatefulWidget {
  const Requests({Key? key, required this.activeRequest}) : super(key: key);

  final int activeRequest;

  @override
  // ignore: library_private_types_in_public_api
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Colors.white.withOpacity(0.07)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            padding:
                MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20)),
          ),
          icon: Padding(
              padding: const EdgeInsets.only(right: 3),
              child: Image.asset('assets/img/file.png')),
          label: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${widget.activeRequest} active requests',
                style: const TextStyle(color: Colors.white),
              )),
          onPressed: () {
            AutoRouter.of(context).push(const InquiresRoute());
          },
        )
      ],
    );
  }
}
