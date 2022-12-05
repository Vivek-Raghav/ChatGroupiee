import 'package:firebase_auth/firebase_auth.dart';

import 'package:chatsystem/Helper/helper_functions.dart';
import 'package:chatsystem/services/auth_services.dart';
import 'package:chatsystem/widgets/drawer.dart';

import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthServices authServices = AuthServices();
  String email = " ";
  String username = " ";

  @override
  void initState() {
    super.initState();
    gettinUserData();
  }

  gettinUserData() async {
    await HelperFunctions.getUserEmailfromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNamefromSF().then((value) {
      setState(() {
        username = value!;
        print(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 150),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              size: 150,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "User Name",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  email,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
            const Divider(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Email",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  username,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            )
          ],
        ),
      ),
      drawer: DrawerScreen(),
    );
  }
}
