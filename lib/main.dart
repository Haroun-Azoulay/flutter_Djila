import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:djila/controllers/auth_service.dart';
import 'package:djila/pages/home_page.dart';
import 'package:djila/pages/login_page.dart';
import 'package:djila/PrivacyPolicy.dart';
import 'package:djila/RightsReservedPage.dart';
import 'package:djila/VersionPage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing Firebase...');
  try {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  } catch(e)
  {
    print('Error initializing Firebase: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
        home: new HomeScreen());
  }
}


  // This widget is the root of your application.
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Djila',
      home: Scaffold(
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
                    IconButton(
                      icon:
                          const Icon(Icons.account_circle, color: Colors.white),
                      tooltip: "Se connecter / S'inscrire",
                      onPressed: () {
                       Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => LoginPage()),
          );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      tooltip: 'Menu',
                      onPressed: () {
                      },
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
                          margin: const EdgeInsets.all(
                              20), // Added margin for better positioning
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: buildCategoryContent(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          // child: buildFooterText(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
 Widget buildCategoryContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildCategoryRow(context, 'images/categories/food.png', 'FoodNight',
            '(dessert, burgers...)'),
        const SizedBox(height: 20),
        buildCategoryRow(context, 'images/categories/grocery.png', 'Grocery',
            '(boissons, snacks...)'),
        const SizedBox(height: 20),
        buildCategoryRow(context, 'images/categories/luxury.png', 'Luxury',
            '(sappes, cosmetiques...)'),
        const SizedBox(height: 20),
        buildCategoryRow(context, 'images/categories/natural.png', 'Natural',
            '(miel, huile de Nigelle...)'),
        const SizedBox(height: 20),
        buildCategoryRow(context, 'images/categories/highTech.png', 'High Tech',
            '(téléphonie, chargeurs...)'),
      ],
    );
  }

  Widget buildFooterText(BuildContext context) {
    return Builder(// Adding Builder here to get the correct context
        builder: (BuildContext context) {
      return RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.white),
          children: [
            TextSpan(
              text: 'Tous droits réservés © 2024 - ',
              style: const TextStyle(decoration: TextDecoration.underline),
              // recognizer: TapGestureRecognizer()
                // ..onTap = () {
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => RightsReservedPage()));
                // },
            ),
            TextSpan(
              text: 'Confidentialité -r',
              style: const TextStyle(decoration: TextDecoration.underline),
              // recognizer: TapGestureRecognizer()
                // ..onTap = () {
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => PrivacyPolicyPage()));
                // },
            ),
            TextSpan(
              text: 'Version 0.00',
              style: const TextStyle(decoration: TextDecoration.underline),
              // recognizer: TapGestureRecognizer()
                // ..onTap = () {
                //   Navigator.push(context,
                //       MaterialPageRoute(builder: (context) => VersionPage()));
                // },
            ),
          ],
        ),
      );
    });
  }

  Widget buildCategoryRow(
      BuildContext context, String imagePath, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        print("$title category tapped!");
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(imagePath), fit: BoxFit.cover),
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
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
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