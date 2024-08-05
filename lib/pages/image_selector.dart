// image_selector.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImageSelector extends StatefulWidget {
  final Function(String) onImageUploaded;

  ImageSelector({required this.onImageUploaded});

  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  File? _image;

  Future<void> _selectImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;
    var imageName = DateTime.now().millisecondsSinceEpoch.toString();
    var storageRef = FirebaseStorage.instance.ref().child('product_images/$imageName.jpg');
    var uploadTask = storageRef.putFile(_image!);
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();
    widget.onImageUploaded(downloadUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(_image!),
          ),
        ),
        ElevatedButton(
          onPressed: _selectImage,
          child: Text('Select image'),
        ),
      ],
    );
  }
}
