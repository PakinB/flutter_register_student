// (ยาวมาก ตัดคำอธิบายออกเพื่อให้ชัดเจน)

import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'user_list_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  final _studentId = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _department = TextEditingController();

  io.File? _imageFile;
  Uint8List? _webImage;
  String? _fileName;

  static const String baseUrl =
      "http://localhost/flutter_register_student/php_api";

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    _fileName = picked.name;

    if (kIsWeb) {
      _webImage = await picked.readAsBytes();
    } else {
      _imageFile = io.File(picked.path);
    }
    setState(() {});
  }

  Future<void> insertUser() async {

    if(_studentId.text.isEmpty ||
       _name.text.isEmpty ||
       _email.text.isEmpty ||
       _phone.text.isEmpty ||
       _department.text.isEmpty ||
       _fileName == null){
         return;
    }

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/insert_user.php"),
    );

    request.fields['student_id'] = _studentId.text.trim();
    request.fields['name'] = _name.text.trim();
    request.fields['email'] = _email.text.trim();
    request.fields['phone'] = _phone.text.trim();
    request.fields['department'] = _department.text.trim();

    if(kIsWeb){
      request.files.add(http.MultipartFile.fromBytes(
        "image", _webImage!, filename: _fileName));
    }else{
      request.files.add(await http.MultipartFile.fromPath(
        "image", _imageFile!.path));
    }

    final response =
        await http.Response.fromStream(await request.send());

    if(response.body.trim()=="success"){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserListPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Registration")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller:_studentId,
              decoration:const InputDecoration(labelText:"Student ID")),
            TextField(controller:_name,
              decoration:const InputDecoration(labelText:"Name")),
            TextField(controller:_email,
              decoration:const InputDecoration(labelText:"Email")),
            TextField(controller:_phone,
              decoration:const InputDecoration(labelText:"Phone")),
            TextField(controller:_department,
              decoration:const InputDecoration(labelText:"Department")),
            const SizedBox(height:15),
            ElevatedButton(
              onPressed:pickImage,
              child:const Text("Choose Image")),
            ElevatedButton(
              onPressed:insertUser,
              child:const Text("Save")),
          ],
        ),
      ),
    );
  }
}