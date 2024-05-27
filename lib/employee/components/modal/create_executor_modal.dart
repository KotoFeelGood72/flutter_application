import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:image_picker/image_picker.dart';

class CreateExecutorModal extends StatefulWidget {
  final int? id;
  final String? type;
  const CreateExecutorModal({super.key, this.id, this.type});

  @override
  State<CreateExecutorModal> createState() => _CreateExecutorModalState();
}

class _CreateExecutorModalState extends State<CreateExecutorModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _keepsTheKeysController = TextEditingController();
  final TextEditingController _internetSpeedController =
      TextEditingController();
  final TextEditingController _internetFeeController = TextEditingController();
  final TextEditingController _internetOperatorController =
      TextEditingController();
  File? _image;

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    _keepsTheKeysController.dispose();
    _internetSpeedController.dispose();
    _internetFeeController.dispose();
    _internetOperatorController.dispose();
    super.dispose();
  }

  void _showSuccessMessage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const SuccessModal(
            message: "The apartment has been successfully added");
      },
    );
  }

  Future<void> _createAppartaments() async {
    FormData formData = FormData.fromMap({
      "apartment_name": _nameController.text,
      "area": _areaController.text,
      "key_holder": _keepsTheKeysController.text,
      "internet_speed": _internetSpeedController.text,
      "internet_fee": _internetFeeController.text,
      "internet_operator": _internetOperatorController.text,
      if (_image != null)
        "photo": await MultipartFile.fromFile(
          _image!.path,
          filename: _image!.path.split('/').last,
        ),
    });

    try {
      if (widget.type == 'employee') {
        await DioSingleton()
            .dio
            .post('employee/apartments/create_apartment', data: formData);
      } else {
        await DioSingleton().dio.post(
            'get_objects_uk/${widget.id}/create_apartment',
            data: formData);
      }
      Navigator.pop(context);
      _showSuccessMessage();
    } catch (e) {
      print("Ошибка при создании апартамента: $e");
      if (e is DioError) {
        print('Dio error: ${e.response?.statusCode} ${e.response?.data}');
      }
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
        child: Wrap(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 30, left: 15, right: 15, bottom: 24),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ModalHeader(title: 'Add appartaments'),
                  const SizedBox(height: 25),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: UkTextField(
                      hint: 'Apartment number',
                      controller: _nameController,
                    ),
                  ),
                  UkTextField(
                    hint: 'Square',
                    controller: _areaController,
                  ),
                  const SizedBox(height: 10),
                  UkTextField(
                    hint: 'Who keeps the keys',
                    controller: _keepsTheKeysController,
                  ),
                  const SizedBox(height: 10),
                  UkTextField(
                    hint: 'Internet speed',
                    controller: _internetSpeedController,
                  ),
                  const SizedBox(height: 10),
                  UkTextField(
                    hint: 'Internet price',
                    controller: _internetFeeController,
                  ),
                  const SizedBox(height: 10),
                  UkTextField(
                    hint: 'Internet operator',
                    controller: _internetOperatorController,
                  ),
                  const SizedBox(height: 10),
                  if (_image != null)
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Stack(
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
                                borderRadius: BorderRadius.circular(5),
                              ),
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
                    ),
                  const SizedBox(height: 10),
                  if (_image == null)
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1.0,
                            color: const Color.fromARGB(166, 223, 223, 223),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.file_download_outlined),
                            SizedBox(width: 10),
                            Text(
                              'Download image',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  CustomBtn(
                    title: 'Add appartaments',
                    onPressed: _createAppartaments,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
