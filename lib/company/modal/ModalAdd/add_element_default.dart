import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';

class AddElementDefault extends StatefulWidget {
  final void Function(String) onAdd;

  const AddElementDefault({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddElementDefaultState createState() => _AddElementDefaultState();
}

class _AddElementDefaultState extends State<AddElementDefault> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ModalHeader(title: 'Add characteristic'),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
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
                title: 'Add characteristic',
                height: 55,
                onPressed: () {
                  if (_textFieldController.text.isNotEmpty) {
                    widget.onAdd(_textFieldController.text);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
