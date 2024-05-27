import 'package:flutter/material.dart';
import 'package:flutter_application/models/CompanyInfo.dart';
import 'package:flutter_application/widget/empty_state.dart';

class RequisitesCard extends StatefulWidget {
  final Requisites? content;
  final EdgeInsetsGeometry padding;
  final double? cardHeight;

  const RequisitesCard({
    super.key,
    this.content,
    this.padding = const EdgeInsets.all(8.0),
    this.cardHeight,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RequisitesCardState createState() => _RequisitesCardState();
}

class _RequisitesCardState extends State<RequisitesCard> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: Column(
        children: [
          Container(
            height: widget.cardHeight,
            decoration: BoxDecoration(
              color: isExpanded
                  ? const Color(0xFFE1E1E1)
                  : const Color(0xFFF5F5F5),
              borderRadius: isExpanded
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))
                  : BorderRadius.circular(10),
            ),
            child: GestureDetector(
              child: ListTile(
                splashColor: Colors.transparent,
                title: const Text(
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
          if (isExpanded) _buildExpandedContent(),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    if (widget.content == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: EmptyState(
          title: "No requisites available",
          text: '',
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRequisitesRow('Recipient', widget.content!.recipient),
            _buildRequisitesRow('INN', widget.content!.inn),
            _buildRequisitesRow('KPP', widget.content!.kpp),
            _buildRequisitesRow('Account', widget.content!.account),
            _buildRequisitesRow('BIC', widget.content!.bic),
            _buildRequisitesRow(
                'Correspondent Account', widget.content!.correspondentAccount),
            _buildRequisitesRow('OKPO', widget.content!.okpo),
            _buildRequisitesRow('Bank Name', widget.content!.bankName),
          ],
        ),
      ),
    );
  }

  Widget _buildRequisitesRow(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color(0xFFA5A5A7),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
