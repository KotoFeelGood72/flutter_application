import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/models/ApartmentId.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application/company/bloc/company_bloc.dart';

class EditApartmentModal extends StatefulWidget {
  final ApartmentId apartment;

  EditApartmentModal({required this.apartment});

  @override
  _EditApartmentModalState createState() => _EditApartmentModalState();
}

class _EditApartmentModalState extends State<EditApartmentModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _areaController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.apartment.apartmentName);
    _areaController =
        TextEditingController(text: widget.apartment.area.toString());
    _loadInitialImage(widget.apartment.photoPath);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialImage(String? url) async {
    if (url != null && url.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(url));
        final documentDirectory = await getApplicationDocumentsDirectory();
        final file = File('${documentDirectory.path}/temp_image.jpg');
        file.writeAsBytesSync(response.bodyBytes);
        setState(() {
          _imageFile = file;
        });
      } catch (e) {
        debugPrint('Error loading image: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _editApartment(ApartmentId updatedApartment) async {
    try {
      final formData = FormData.fromMap({
        'apartment_name': updatedApartment.apartmentName,
        'area': updatedApartment.area,
        if (_imageFile != null)
          'photo': await MultipartFile.fromFile(_imageFile!.path),
      });

      debugPrint('Form data: ${formData.fields}, ${formData.files}');

      final response = await DioSingleton().dio.put(
            'employee/apartments/apartment_info/${widget.apartment.id}/update-info',
            data: formData,
          );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final _companyBloc =
            BlocProvider.of<CompanyBloc>(context, listen: false);
        _companyBloc.add(AppartamentsLoaded(widget.apartment.id));
        Navigator.of(context).pop();
      } else {
        debugPrint('Error: ${response.statusCode}');
        // Handle error
      }
    } catch (e) {
      debugPrint('Exception: $e');
      // Handle error
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final updatedApartment = widget.apartment.copyWith(
        apartmentName: _nameController.text,
        area: double.parse(_areaController.text),
        photoPath: _imageFile?.path,
      );
      debugPrint('Updated apartment: $updatedApartment');
      _editApartment(updatedApartment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UkTextField(
                hint: 'Name apartments',
                controller: _nameController,
              ),
              const SizedBox(height: 10),
              UkTextField(
                hint: 'Area apartments',
                controller: _areaController,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashPattern: [8, 4],
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    color: Colors.grey.shade200,
                    child: _imageFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload,
                                  size: 50, color: Colors.grey),
                              Text('Upload files',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          )
                        : Image.file(_imageFile!, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomBtn(
                onPressed: _save,
                title: 'Edit apartments',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
