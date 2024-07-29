import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:djila/main.dart';

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

  Future<void> addData(String title, String description, String category) async {
    CollectionReference products = FirebaseFirestore.instance.collection('products');
    
  
    await products.add({
      'userId': widget.user.uid,
      'title': title,
      'description': description,
      'category': category,
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
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addData(_titleController.text, _descriptionController.text, _selectedCategory);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Produit ajouté avec succès')),
                    );
                                 Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
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
