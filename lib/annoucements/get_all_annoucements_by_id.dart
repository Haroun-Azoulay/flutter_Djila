import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetAllAnnoucementsById extends StatelessWidget {
  final String userId;

  GetAllAnnoucementsById({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Announcements'),
      ),
      body: Center(
        child: AnnoucementsById(userId: userId),
      ),
    );
  }
}

class AnnoucementsById extends StatelessWidget {
  final String userId;

  AnnoucementsById({required this.userId});

  final CollectionReference products = FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: products.where('userId', isEqualTo: userId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Une erreur est survenue'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Aucun produit trouvé pour l\'utilisateur'));
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

            return ListTile(
              title: Text(data['productName'] ?? 'No Name'),
              subtitle: Text(data['description'] ?? 'No Description'),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteAnnouncement(document.id);
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _deleteAnnouncement(String docId) {
    products.doc(docId).delete().then((_) {
      print("Announcement deleted");
    }).catchError((error) {
      print("Failed to delete announcement: $error");
    });
  }
}
