import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcard/tcard.dart';

class GetAllProductsPage extends StatelessWidget {
  final String category;

  GetAllProductsPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Produits de $category')),
      body: ProductsList(category: category),
    );
  }
}

class ProductsList extends StatelessWidget {
  final String category;
  final CollectionReference products = FirebaseFirestore.instance.collection('products');

  ProductsList({required this.category});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: products.where('category', isEqualTo: category).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Une erreur est survenue'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Aucun produit trouvé dans la catégorie $category'));
        }

        List<DocumentSnapshot> documents = snapshot.data!.docs;
        List<Widget> cards = documents.map((document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return Card(
            child: Column(
              children: [
                data['image'] != null
                    ? Image.network(data['image'], width: double.infinity, height: 300, fit: BoxFit.cover)
                    : Container(width: double.infinity, height: 300, color: Colors.grey),
                ListTile(
                  title: Text(data['title']),
                  subtitle: Text(data['description']),
                ),
              ],
            ),
          );
        }).toList();

        return Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: TCard(
              cards: cards,
              size: Size(MediaQuery.of(context).size.width * 0.9, MediaQuery.of(context).size.height * 0.75),
              onForward: (index, info) {
                // Handle swipe forward event
              },
              onBack: (index, info) {
                // Handle swipe back event
              },
              onEnd: () {
                // Handle end of swipe cards
              },
            ),
          ),
        );
      },
    );
  }
}
