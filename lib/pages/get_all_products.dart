import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcard/tcard.dart';

const List<String> departments = <String>[
  '01 - Ain', '02 - Aisne', '03 - Allier', '04 - Alpes-de-Haute-Provence', '05 - Hautes-Alpes',
  '06 - Alpes-Maritimes', '07 - Ardèche', '08 - Ardennes', '09 - Ariège', '10 - Aube',
  '11 - Aude', '12 - Aveyron', '13 - Bouches-du-Rhône', '14 - Calvados', '15 - Cantal',
  '16 - Charente', '17 - Charente-Maritime', '18 - Cher', '19 - Corrèze', '2A - Corse-du-Sud',
  '2B - Haute-Corse', '21 - Côte-d\'Or', '22 - Côtes-d\'Armor', '23 - Creuse', '24 - Dordogne',
  '25 - Doubs', '26 - Drôme', '27 - Eure', '28 - Eure-et-Loir', '29 - Finistère',
  '30 - Gard', '31 - Haute-Garonne', '32 - Gers', '33 - Gironde', '34 - Hérault',
  '35 - Ille-et-Vilaine', '36 - Indre', '37 - Indre-et-Loire', '38 - Isère', '39 - Jura',
  '40 - Landes', '41 - Loir-et-Cher', '42 - Loire', '43 - Haute-Loire', '44 - Loire-Atlantique',
  '45 - Loiret', '46 - Lot', '47 - Lot-et-Garonne', '48 - Lozère', '49 - Maine-et-Loire',
  '50 - Manche', '51 - Marne', '52 - Haute-Marne', '53 - Mayenne', '54 - Meurthe-et-Moselle',
  '55 - Meuse', '56 - Morbihan', '57 - Moselle', '58 - Nièvre', '59 - Nord',
  '60 - Oise', '61 - Orne', '62 - Pas-de-Calais', '63 - Puy-de-Dôme', '64 - Pyrénées-Atlantiques',
  '65 - Hautes-Pyrénées', '66 - Pyrénées-Orientales', '67 - Bas-Rhin', '68 - Haut-Rhin', '69 - Rhône',
  '70 - Haute-Saône', '71 - Saône-et-Loire', '72 - Sarthe', '73 - Savoie', '74 - Haute-Savoie',
  '75 - Paris', '76 - Seine-Maritime', '77 - Seine-et-Marne', '78 - Yvelines', '79 - Deux-Sèvres',
  '80 - Somme', '81 - Tarn', '82 - Tarn-et-Garonne', '83 - Var', '84 - Vaucluse',
  '85 - Vendée', '86 - Vienne', '87 - Haute-Vienne', '88 - Vosges', '89 - Yonne',
  '90 - Territoire de Belfort', '91 - Essonne', '92 - Hauts-de-Seine', '93 - Seine-Saint-Denis', '94 - Val-de-Marne',
  '95 - Val-d\'Oise'
];

class GetAllProductsPage extends StatefulWidget {
  final String category;

  GetAllProductsPage({required this.category});

  @override
  _GetAllProductsPageState createState() => _GetAllProductsPageState();
}

class _GetAllProductsPageState extends State<GetAllProductsPage> {
  String _selectedDepartment = departments.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Produits de ${widget.category}')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedDepartment,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Sélectionnez un département',
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDepartment = newValue!;
                });
              },
              items: departments.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ProductsList(
              category: widget.category,
              department: _selectedDepartment,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductsList extends StatelessWidget {
  final String category;
  final String department;
  final CollectionReference products = FirebaseFirestore.instance.collection('products');

  ProductsList({required this.category, required this.department});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: products
          .where('category', isEqualTo: category)
          .where('department', isEqualTo: department)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Une erreur est survenue'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Aucun produit trouvé dans la catégorie $category pour le département $department'));
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
