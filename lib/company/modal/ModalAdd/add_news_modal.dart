import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:flutter_application/components/ui/custom_dropdown.dart';
import 'package:flutter_application/components/ui/toggle_switch.dart';
import 'package:image_picker/image_picker.dart'; // Необходимо добавить в pubspec.yaml

class AddNewsModal extends StatefulWidget {
  AddNewsModal({Key? key}) : super(key: key);

  @override
  State<AddNewsModal> createState() => _AddNewsModalState();
}

class _AddNewsModalState extends State<AddNewsModal> {
  late TextEditingController _textarea;
  final List<XFile> _mediaList = [];

  @override
  void initState() {
    super.initState();
    _textarea = TextEditingController();
  }

  @override
  void dispose() {
    _textarea.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _mediaList.add(file);
      });
    }
  }

  void _removeMedia(int index) {
    setState(() {
      _mediaList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 24),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add News',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color.fromARGB(255, 235, 234, 234),
                  ),
                  child: IconButton(
                      color: const Color(0xFFB4B7B8),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero,
                      iconSize: 12,
                      icon: const Icon(
                        Icons.close,
                      )),
                ),
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(minHeight: 300),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _textarea,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Text',
                          hintStyle: TextStyle(color: Colors.black),
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 79,
                      height: 53,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(15)),
                      child: GestureDetector(
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
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 15),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(15)),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _mediaList.length,
                          itemBuilder: (context, index) {
                            String fileName = path.basenameWithoutExtension(
                                _mediaList[index].path);
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFA5A5A7),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.file(
                                        File(_mediaList[index].path),
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      fileName,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () => _removeMedia(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFF5F5F5),
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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
              ToggleSwitch(
                leftTabName: "Push notification",
                rightTabName: "Email notification",
                initialValue: false,
                onToggle: (value) {
                  print("Текущее значение: $value");
                },
              ),
              const SizedBox(height: 10),
              CustomDropdown(),
              const SizedBox(height: 20),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF6873D1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'To publish',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
