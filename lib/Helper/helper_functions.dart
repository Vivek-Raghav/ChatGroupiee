import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
// saving the data to SF

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final loginStatus =
        await sharedPreferences.setBool('LOGGEDINKEY', isUserLoggedIn);

// {'LOGGEDINKEY':true}

    print('cache memory login Status $loginStatus');
    return loginStatus;
  }

  static getUserDetails() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString('userNameKey', userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString('USEREMAILKEY', userEmail);
  }

// getting the data from SF
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool('LOGGEDINKEY');
  }

  static Future<String?> getUserEmailfromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString('USEREMAILKEY');
  }

  static Future<String?> getUserNamefromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString('userNameKey');
  }
}
