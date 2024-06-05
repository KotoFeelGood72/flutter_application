import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/components/ui/custom_dropdown.dart';
import 'package:flutter_application/models/user_item_news.dart';
import 'package:image_picker/image_picker.dart';

class AddNewsModal extends StatefulWidget {
  const AddNewsModal({Key? key}) : super(key: key);

  @override
  State<AddNewsModal> createState() => _AddNewsModalState();
}

class _AddNewsModalState extends State<AddNewsModal> {
  late TextEditingController _titleController;
  late TextEditingController _textarea;
  final List<XFile> _mediaList = [];
  List<UserItemNews> userItemNewsList = [];
  UserItemNews? selectedUserItem;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _textarea = TextEditingController();
    _getClientMetters();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textarea.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    if (_mediaList.isNotEmpty) {
      return; // Already one image is added
    }

    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _mediaList.add(file);
      });
    }
  }

  Future<void> _getClientMetters() async {
    try {
      final response = await DioSingleton().dio.get('add-news');
      List<UserItemNews> fetchedList = (response.data as List)
          .map((json) => UserItemNews.fromJson(json))
          .toList();

      if (!fetchedList.any((item) => item.name == 'All users')) {
        fetchedList.insert(0, UserItemNews(id: 'all', name: 'All users'));
      }

      setState(() {
        userItemNewsList = fetchedList;
        selectedUserItem = fetchedList.firstWhere(
          (item) => item.name == 'All users',
          orElse: () => fetchedList[0],
        );
      });

      // Отладочная информация
      print('Fetched list: ${fetchedList.map((e) => e.name).toList()}');
      print('Selected user item: ${selectedUserItem?.name}');
    } catch (e) {
      print(e);
    }
  }

  void _showSuccessMessage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const SuccessModal(
          message: "The order has been successfully added in progress",
        );
      },
    );
  }

  Future<void> _createNews() async {
    if (_titleController.text.isEmpty ||
        _textarea.text.isEmpty ||
        selectedUserItem == null) {
      print("Please fill all fields");
      return;
    }

    FormData formData = FormData.fromMap({
      "name": _titleController.text,
      "description": _textarea.text,
      "apartment": selectedUserItem!.id,
      if (_mediaList.isNotEmpty)
        "photo": await MultipartFile.fromFile(
          _mediaList[0].path,
          filename: _mediaList[0].path.split('/').last,
        ),
    });

    try {
      final response =
          await DioSingleton().dio.post('add-news', data: formData);
      Navigator.pop(context);
      _showSuccessMessage();
    } catch (e) {
      // print("Error creating news: $e");
      if (e is DioError) {
        print('Dio error: ${e.response?.statusCode} ${e.response?.data}');
      }
    }
  }

  void _removeMedia(int index) {
    setState(() {
      _mediaList.removeAt(index);
    });
  }

  void _onDropdownChanged(UserItemNews selectedItem) {
    setState(() {
      selectedUserItem = selectedItem;
    });
    print('Selected item: ${selectedItem.name}, ID: ${selectedItem.id}');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 24),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ModalHeader(title: 'Add a news'),
            UkTextField(
              hint: 'Press title news',
              controller: _titleController,
            ),
            const SizedBox(height: 10),
            Container(
              constraints: const BoxConstraints(minHeight: 300),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFF5F5F5)),
                          child: TextFormField(
                            controller: _textarea,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Press text',
                              hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (_mediaList.isEmpty)
                        Container(
                          width: 79,
                          height: 53,
                          decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(15)),
                          child: InkWell(
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: _pickMedia,
                            child: Transform.rotate(
                              angle: 45 * 3.141592653589793238 / 180,
                              child: const Icon(
                                Icons.attach_file,
                                color: Color(0xFFA5A5A7),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _mediaList.isNotEmpty
                      ? Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(right: 15, bottom: 15),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.file(
                                  File(_mediaList[0].path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: InkWell(
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () => _removeMedia(0),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                                255, 255, 255, 255)
                                            .withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(2)),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Color.fromARGB(255, 185, 64, 55),
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Publishing Options',
                    style: TextStyle(
                        color: Color(0xFF73797C), fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 10),
                CustomDropdown(
                  list: userItemNewsList,
                  onChanged: _onDropdownChanged,
                  initialValue: selectedUserItem,
                ),
                const SizedBox(height: 20),
                CustomBtn(
                  title: 'To publish',
                  onPressed: _createNews,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
