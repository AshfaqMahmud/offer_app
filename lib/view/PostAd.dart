import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offer_app/database/DBHelper.dart';
import '../model/AdModel.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class AdForm extends StatefulWidget {
  @override
  _AdFormState createState() => _AdFormState();
}

class _AdFormState extends State<AdForm> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<File?> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = join(dir.absolute.path, "${DateTime.now().millisecondsSinceEpoch}.jpg");

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
    );

    return result;
  }

  Future<void> _saveAd() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage != null) {
        // Compress the image
        File? compressedImage = await _compressImage(_selectedImage!);

        if (compressedImage != null) {
          String adDescription = _descriptionController.text;

          Ad newAd = Ad(adImage: compressedImage.path, adDescription: adDescription);
          await DBhelper().insertAd(newAd);

          ScaffoldMessenger.of(context as BuildContext).showSnackBar(
            SnackBar(content: Text('Ad saved successfully!')),
          );

          // Clear the form
          _descriptionController.clear();
          setState(() {
            _selectedImage = null;
          });
        }
      } else {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Please select an image.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Ad'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _selectedImage == null
                    ? Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: Center(
                    child: Text('Tap to select an image'),
                  ),
                )
                    : Image.file(_selectedImage!, height: 150),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Ad Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAd,
                child: Text('Save Ad'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
