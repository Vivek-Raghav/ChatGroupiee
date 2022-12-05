import 'package:chatsystem/Helper/helper_functions.dart';
import 'package:chatsystem/Screens/HomeScreen.dart';
import 'package:chatsystem/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkIfUserIsLogined() async {
    bool? isUserLoginedInApp = await HelperFunctions.getUserLoggedInStatus();

    if (isUserLoginedInApp == true) {
      if (!mounted) {
        return;
      }

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      if (!mounted) {
        return;
      }
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfUserIsLogined();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 100, bottom: 100),
      width: double.infinity,
      height: double.infinity,
      child: Image.asset("assets/images/Group.jpg"),
    );
  }
}
