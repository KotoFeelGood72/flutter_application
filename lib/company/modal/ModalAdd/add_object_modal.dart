import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:image_picker/image_picker.dart';

class AddObjectModal extends StatefulWidget {
  const AddObjectModal({super.key});

  @override
  State<AddObjectModal> createState() => _AddObjectModalState();
}

class _AddObjectModalState extends State<AddObjectModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? _image;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _createObject() async {
    FormData formData = FormData.fromMap({
      "object_name": _nameController.text,
      "object_address": _addressController.text,
      if (_image != null)
        "photo": await MultipartFile.fromFile(_image!.path,
            filename: _image!.path.split('/').last),
    });

    try {
      final response =
          await DioSingleton().dio.post('create_object', data: formData);
      Navigator.pop(context);
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const SuccessModal(
              message: "The object has been successfully added");
        },
      );
    } catch (e) {
      // print('Ошибка при создании объекта: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _deleteImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: 445,
          padding:
              const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 24),
          color: Colors.white,
          child: Column(
            children: [
              const ModalHeader(title: 'Add an object'),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: UkTextField(
                        hint: 'Name of the object',
                        controller: _nameController,
                      ),
                    ),
                    UkTextField(
                      hint: 'Address',
                      controller: _addressController,
                    ),
                    const SizedBox(height: 10),
                    if (_image != null)
                      Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(_image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: GestureDetector(
                                onTap: _deleteImage,
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    if (_image == null)
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(minHeight: 55),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1.0,
                                  color: const Color.fromARGB(
                                      166, 223, 223, 223))),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.file_download_outlined),
                              SizedBox(width: 10),
                              Text(
                                'Download image',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              CustomBtn(
                  height: 55,
                  title: 'Add an object',
                  onPressed: () {
                    _createObject();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
