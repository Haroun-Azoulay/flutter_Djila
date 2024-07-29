import 'package:flutter/material.dart';
import 'package:djila/controllers/auth_service.dart';
import 'package:djila/main.dart';
import 'package:djila/main.dart';
import 'package:telephony/telephony.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Telephony telephony = Telephony.instance;

  TextEditingController _phoneContoller = TextEditingController();
  TextEditingController _otpContoller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  void listenToIncomingSMS(BuildContext context) {
    print("Listening to sms.");
    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          // Handle message
          print("sms received : ${message.body}");
          // verify if we are reading the correct sms or not

          if (message.body!.contains("phone-auth-15bdb")) {
            String otpCode = message.body!.substring(0, 6);
            setState(() {
              _otpContoller.text = otpCode;
              // wait for 1 sec and then press handle submit
              Future.delayed(Duration(seconds: 1), () {
                handleSubmit(context);
              });
            });
          }
        },
        listenInBackground: false);
  }

// handle after otp is submitted
  void handleSubmit(BuildContext context) {
    if (_formKey1.currentState!.validate()) {
      AuthService.loginWithOtp(otp: _otpContoller.text).then((value) {
        if (value == "Success") {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/wallpaper.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
 Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                  Image.asset(
                    'images/logohome.png',
                    width: 200,
                    height: 200,
                  ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    SizedBox(
                      height:
                          200),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: const Text('Revenir au menu'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    )
                  ),
                  SizedBox(
                      height:
                          30),
                  Text(
                    "Connexion",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Text("Enter your phone number to continue."),
                  SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white, fontSize: 24,),
                      controller: _phoneContoller,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixText: "+33 ",
                          prefixStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                        labelText: "Entrer votre numéro de mobile",
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      validator: (value) {
                        if (value!.length != 10) return "Numéro de mobile invalide";
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          AuthService.sentOtp(
                              phone: _phoneContoller.text,
                              errorStep: () => ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Error in sending OTP",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  )),
                              nextStep: () {
                                // start lisenting for otp
                                listenToIncomingSMS(context);
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("Verification Code de sécurité"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Entrer les 6 chiffres"),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Form(
                                                key: _formKey1,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: _otpContoller,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          "Entrer votre numéro de mobile",
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      32))),
                                                  validator: (value) {
                                                    if (value!.length != 6)
                                                      return "Le code de verification est invalide";
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    handleSubmit(context),
                                                child: Text("Envoyer"))
                                          ],
                                        ));
                              });
                        }
                      },
                      child: Text("Envoyez un code de verification"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          )
          ],
        ),
      );
  }
}
