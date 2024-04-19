import 'package:flutter/material.dart';

class RequisitesCard extends StatefulWidget {
  final dynamic content;
  const RequisitesCard({super.key, required this.content});

  @override
  _RequisitesCardState createState() => _RequisitesCardState();
}

class _RequisitesCardState extends State<RequisitesCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isExpanded
                  ? const Color(0xFFE1E1E1)
                  : const Color(0xFFF5F5F5),
              borderRadius: isExpanded
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )
                  : BorderRadius.circular(10),
            ),
            child: InkWell(
              highlightColor: Colors.transparent,
              child: ListTile(
                splashColor: Colors.transparent,
                minVerticalPadding: 20,
                title: Text(
                  'Bank requisites',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: isExpanded
                    ? const Icon(Icons.expand_less)
                    : const Icon(Icons.expand_more),
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            ),
          ),
          isExpanded ? _buildExpandedContent() : Container(),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, bottom: 16.0, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildRequisitesRow(
                'Recipient', '${widget.content['Requisites']['recipient']}'),
            _buildRequisitesRow(
                'INN', '${widget.content['Requisites']['inn']}'),
            _buildRequisitesRow(
                'KPP', '${widget.content['Requisites']['kpp']}'),
            _buildRequisitesRow(
                'Account', '${widget.content['Requisites']['account']}'),
            _buildRequisitesRow(
                'BIC', '${widget.content['Requisites']['bic']}'),
            _buildRequisitesRow('Correspondent account',
                '${widget.content['Requisites']['correspondent_account']}'),
            _buildRequisitesRow(
                'OKPO', '${widget.content['Requisites']['okpo']}'),
            _buildRequisitesRow(
                'Bank name', '${widget.content['Requisites']['bank_name']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildRequisitesRow(String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFFA5A5A7)),
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
