import 'package:chatsystem/Helper/helper_functions.dart';
import 'package:chatsystem/Screens/HomeScreen.dart';
import 'package:chatsystem/services/auth_services.dart';
import 'package:chatsystem/widgets/elevatedbutton.dart';
import 'package:chatsystem/Screens/LoginScreen.dart';
import 'package:chatsystem/widgets/widgets.dart';

import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  // SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  AuthServices authServices = AuthServices();

  final signupKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void register() async {
    if (signupKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
    }

    await authServices
        .registerUserwithEmailandPassword(namecontroller.text.trim(),
            emailcontroller.text.trim(), passwordcontroller.text.trim())
        .then((value) async {
      if (value == true) {
// Now the users is registered and ready to more forward

// now we will save user credentials into share preferences

        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserEmailSF(emailcontroller.text.trim());
        await HelperFunctions.saveUserNameSF(namecontroller.text.trim());
        if (!mounted) {
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        showSnackbar(context, Colors.red, value);
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: signupKey,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    height: MediaQuery.of(context).size.height,
                    // width: MediaQuery.of(context).size.width,
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
                          controller: namecontroller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Full Name",
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: emailcontroller,
                          validator: (value) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)
                                ? null
                                : "Please Enter Valid Email ";
                            // if (value!.contains("@") == false ||
                            //     value.contains('.com') == false) {
                            //   return 'Please use authorized email';
                            // }
                            // return null;
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
                          controller: passwordcontroller,
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
                            innertext: "Sign Up",
                            innercolor: Theme.of(context).primaryColor,
                            onTapped: () {
                              register();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account ? ",
                              style: TextStyle(fontSize: 18),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: const Text(
                                " Login Now",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
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
              ),
            ),
    );
  }
}
