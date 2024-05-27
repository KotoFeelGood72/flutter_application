import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  Map<String, bool> sectionIsExpanded = {
    'contact_center': true,
    'offers_feedback': true,
    'technical_support': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(top: 40),
        children: [
          AppBar(
            title: const Text('Contacts',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600)),
            elevation: 0,
            centerTitle: true,
            leading: Container(
              margin: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                icon: Image.asset(
                  'assets/img/back-gray.png',
                  width: 22,
                  height: 22,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          const SizedBox(height: 15),
          _buildAccordionSection(
            context,
            title: 'Unified Contact Center',
            subtitle: 'Comfort Service (24/7)',
            sectionKey: 'contact_center',
            children: [
              const SizedBox(height: 15),
              const ContactsItem(
                text: '+7 (495) 150-08-02',
                img: 'phone.png',
              ),
              const SizedBox(height: 15),
              const ContactsItem(
                text: 'smart17@smindex.com',
                img: 'phone.png',
              ),
              const SizedBox(height: 15),
            ],
          ),
          _buildAccordionSection(
            context,
            title: 'Offers and Feedback',
            subtitle:
                'If you have any comments or suggestions regarding the quality of our services, please write to us',
            sectionKey: 'offers_feedback',
            children: [
              const SizedBox(height: 15),
              const ContactsItem(
                text: 'maintenance@sminex.com',
                img: 'phone.png',
              ),
              const SizedBox(height: 15),
            ],
          ),
          _buildAccordionSection(
            context,
            title: 'Mobile Application Technical Support',
            subtitle: 'Mobile Application Technical Support',
            sectionKey: 'technical_support',
            children: [
              const SizedBox(height: 15),
              const ContactsItem(
                text: '+7 (495) 150-08-02',
                img: 'phone.png',
              ),
              const SizedBox(height: 15),
              const ContactsItem(
                text: 'smart17@smindex.com',
                img: 'phone.png',
              ),
              const SizedBox(height: 15),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccordionSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String sectionKey,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              sectionIsExpanded[sectionKey] =
                  !(sectionIsExpanded[sectionKey] ?? false);
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                border: const Border(
                  top: BorderSide(
                    color: Color.fromRGBO(135, 142, 146, 0.36),
                    width: 1.0,
                  ),
                  bottom: BorderSide(
                    color: Color.fromRGBO(135, 142, 146, 0.36),
                    width: 1.0,
                  ),
                ),
                color: sectionIsExpanded[sectionKey]!
                    ? const Color(0xFFF5F5F5)
                    : const Color.fromARGB(255, 255, 255, 255)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6873D1)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                            color: Color(0xFF73797C),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Icon(
                  sectionIsExpanded[sectionKey]!
                      ? Icons.expand_less
                      : Icons.expand_more,
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: ConstrainedBox(
            constraints: sectionIsExpanded[sectionKey]!
                ? const BoxConstraints()
                : const BoxConstraints(maxHeight: 0),
            child: Column(
              children: children
                  .map((child) => Container(
                        child: child,
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class ContactsItem extends StatelessWidget {
  final String text;
  final String img;

  const ContactsItem({
    Key? key,
    required this.text,
    required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF6873D1),
            borderRadius: BorderRadius.circular(10),
          ),
          width: 35,
          height: 35,
          child: Image.asset('assets/img/$img')),
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
