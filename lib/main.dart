import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:djila/controllers/auth_service.dart';
import 'package:djila/pages/login_page.dart';
import 'package:djila/pages/add_product.dart';
import 'package:djila/pages/get_all_products.dart';
import 'package:djila/PrivacyPolicy.dart';
import 'package:djila/RightsReservedPage.dart';
import 'package:djila/VersionPage.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing Firebase...');
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoggedIn = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await AuthService.isLoggedIn();
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _isLoggedIn = isLoggedIn;
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/wallpaper.png',
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              AppBar(
                toolbarHeight: 100,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Image.asset(
                  'images/logohome.png',
                  fit: BoxFit.contain,
                  width: 100,
                  height: 100,
                ),
                actions: [
                  _isLoggedIn
                      ? OutlinedButton(
                          onPressed: () {
                            AuthService.logout();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Deconnexion",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          ),
                          tooltip: "Se connecter / S'inscrire",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                        ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onSelected: (String result) {
                      setState(() {
                        switch (result) {
                          case 'Mes Annonces':
                            break;
                          case 'Paiements':
                            break;
                          case 'Contact':
                            break;
                          case 'Deconnexion':
                            break;
                        }
                      });
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: "Mes Annonces",
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.shopping_cart_rounded),
                            ),
                            const Text(
                              'Mes Annonces',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: "Paiements",
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.add_card),
                            ),
                            const Text(
                              'Paiements',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: "Contact",
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.comment),
                            ),
                            const Text(
                              'Contact',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: "Deconnexion",
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.account_circle),
                            ),
                            const Text(
                              'Deconnexion',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: 300,
                        height: 500,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _isLoggedIn
                                ? OutlinedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddProductPage(user: _user!),
                                        ),
                                      );
                                    },
                                    child: Icon(Icons.add_circle, color: Colors.black),
                                  )
                                : SizedBox.shrink(),
                            Expanded(
                              child: buildCategoryContent(context),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: buildFooterText(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCategoryContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildCategoryRow(context, 'images/categories/food.png', 'Food Night', '(dessert, burgers...)'),
        const SizedBox(height: 20),
        buildCategoryRow(context, 'images/categories/grocery.png', 'Epicerie', '(boissons, snacks...)'),
        const SizedBox(height: 20),
        buildCategoryRow(context, 'images/categories/luxury.png', 'Luxe', '(sappes, cosmetiques...)'),
        const SizedBox(height: 20),
        buildCategoryRow(context, 'images/categories/natural.png', 'Naturel', '(miel, huile de Nigelle...)'),
        const SizedBox(height: 20),
        buildCategoryRow(context, 'images/categories/highTech.png', 'High Tech', '(téléphonie, chargeurs...)'),
      ],
    );
  }

  Widget buildFooterText(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 12, color: Colors.white),
            children: [
              TextSpan(
                text: 'Tous droits réservés © 2024 - ',
              ),
              TextSpan(
                text: 'Confidentialité - ',
              ),
              TextSpan(
                text: 'Version 0.00',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildCategoryRow(BuildContext context, String imagePath, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GetAllProductsPage(category: title),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(35),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle.toLowerCase(),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class CheckUserLoggedInOrNot extends StatefulWidget {
//   const CheckUserLoggedInOrNot({super.key});

//   @override
//   State<CheckUserLoggedInOrNot> createState() => _CheckUserLoggedInOrNotState();
// }

// class _CheckUserLoggedInOrNotState extends State<CheckUserLoggedInOrNot> {
//   @override
//   void initState() {
//     AuthService.isLoggedIn().then((value) {
//       if (value) {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => HomePage()));
//       } else {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => LoginPage()));
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }