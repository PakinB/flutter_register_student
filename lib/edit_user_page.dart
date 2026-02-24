// (ย่อคำอธิบาย)

import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditUserPage extends StatefulWidget {
  final Map user;
  const EditUserPage({super.key, required this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {

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

  @override
  void initState(){
    _studentId.text = widget.user['student_id'];
    _name.text = widget.user['name'];
    _email.text = widget.user['email'];
    _phone.text = widget.user['phone'];
    _department.text = widget.user['department'];
    super.initState();
  }

  Future<void> updateUser() async {

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/update_user.php"),
    );

    request.fields['id'] = widget.user['id'].toString();
    request.fields['student_id'] = _studentId.text.trim();
    request.fields['name'] = _name.text.trim();
    request.fields['email'] = _email.text.trim();
    request.fields['phone'] = _phone.text.trim();
    request.fields['department'] = _department.text.trim();

    if(_fileName!=null){
      if(kIsWeb){
        request.files.add(http.MultipartFile.fromBytes(
          "image", _webImage!, filename:_fileName));
      }else{
        request.files.add(await http.MultipartFile.fromPath(
          "image", _imageFile!.path));
      }
    }

    final response =
      await http.Response.fromStream(await request.send());

    if(response.body.trim()=="success"){
      Navigator.pop(context,true);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Student")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children:[
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
              onPressed:updateUser,
              child:const Text("Update")),
          ],
        ),
      ),
    );
  }
}