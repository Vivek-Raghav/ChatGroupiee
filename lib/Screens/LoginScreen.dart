import 'package:chatsystem/Helper/helper_functions.dart';
import 'package:chatsystem/Screens/HomeScreen.dart';
import 'package:chatsystem/services/auth_services.dart';
import 'package:chatsystem/services/data_service.dart';
import 'package:chatsystem/widgets/elevatedbutton.dart';
import 'package:chatsystem/Screens/signupScreen.dart';
import 'package:chatsystem/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  AuthServices authServices = AuthServices();
  bool _isloading = false;

  login() async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
    }

    await authServices
        .loginInwithEmailandPassword(
            emailcontroller.text.trim(), passwordcontroller.text.trim())
        .then((value) async {
      if (value == true) {
        QuerySnapshot snapshot =
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .gettingUserData(emailcontroller.text.trim());

        // saving the values to our shared preferenes and will work on reboot the app
        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserEmailSF(emailcontroller.text.trim());
        await HelperFunctions.saveUserNameSF(snapshot.docs[0]["fullName"]);

        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );

        // Will move to the next screen when the data on shared preference matched with appp
      } else {
        showSnackbar(context, Colors.red, value);
        setState(() {
          _isloading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30),
                      height: screenSize.height,
                      child: Form(
                        key: _loginFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Groupie",
                              style: TextStyle(
                                  fontSize: 34, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Lgin now to see what they are talking",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            Image.asset("assets/images/groupe.png"),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: emailcontroller,
                              // controller: textEditingController,
                              validator: (value) {
                                if (value!.contains("@") == false ||
                                    value.contains('.com') == false) {
                                  return 'Please use authorized email';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Email",
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: passwordcontroller,
                              // controller: textEditingController,
                              validator: (value) {
                                if (value!.length < 6) {
                                  return 'Input shoud not be less than 6';
                                }

                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Password",
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 35,
                              width: double.infinity,
                              child: ElevateButton(
                                  onTapped: () {
                                    login();
                                  },
                                  innertext: "Login",
                                  innercolor: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account ? ",
                                  style: TextStyle(fontSize: 18),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen()));
                                  },
                                  child: const Text(
                                    " Register Here",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
