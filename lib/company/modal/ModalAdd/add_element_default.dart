import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';

class AddElementDefault extends StatelessWidget {
  final void Function(String) onAdd;
  final TextEditingController _textFieldController = TextEditingController();

  AddElementDefault({Key? key, required this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: ListView(
        shrinkWrap: true,
        children: [
          ModalHeader(title: 'Add characteristic'),
          SizedBox(height: 20),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.black26,
                      width: 1,
                    ),
                  ),
                  child: UkTextField(
                    hint: 'Press text',
                    controller: _textFieldController,
                  ),
                ),
                CustomBtn(
                    title: 'Add',
                    onPressed: () {
                      if (_textFieldController.text.isNotEmpty) {
                        onAdd(_textFieldController.text);
                        Navigator.pop(context);
                      }
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
