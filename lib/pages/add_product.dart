// add_product_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:djila/main.dart';
import 'package:djila/pages/image_selector.dart';

class AddProductPage extends StatelessWidget {
  final User user;

  AddProductPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter Produit')),
      backgroundColor: Colors.white,
      body: MyCustomForm(user: user),
    );
  }
}

const List<String> list = <String>['Food Night', 'Epicerie', 'Luxe', 'Naturel', 'High Tech'];

class MyCustomForm extends StatefulWidget {
  final User user;
  const MyCustomForm({required this.user, super.key});
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = list.first;
  String? _imageUrl;

  Future<void> addData(String title, String description, String category, String imageUrl) async {
    CollectionReference products = FirebaseFirestore.instance.collection('products');

    await products.add({
      'userId': widget.user.uid,
      'title': title,
      'description': description,
      'category': category,
      'image': imageUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: DropdownButtonFormField<String>(
                value: _selectedCategory,
                icon: const Icon(Icons.arrow_downward),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Catégorie',
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Titre du produit',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le titre du produit';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la description du produit';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ImageSelector(
                onImageUploaded: (String imageUrl) {
                  setState(() {
                    _imageUrl = imageUrl;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_imageUrl != null) {
                      await addData(
                        _titleController.text,
                        _descriptionController.text,
                        _selectedCategory,
                        _imageUrl!,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Produit ajouté avec succès')),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Veuillez sélectionner une image')),
                      );
                    }
                  }
                },
                child: Text('Envoyez'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
