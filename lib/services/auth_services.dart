import 'package:chatsystem/Helper/helper_functions.dart';
import 'package:chatsystem/services/data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future loginInwithEmailandPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print('Iam the error ${e.toString()}');
      return e.toString();
    }
  }

// ------------------------------------------------------------------------------------------------------------------------

  Future registerUserwithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // print(userCredential.toString());

      if (userCredential.user != null) {
        DatabaseService databaseService =
            DatabaseService(uid: userCredential.user!.uid);

        databaseService.updateUserData(fullName: fullName, email: email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print('Iam the error ${e.toString()}');
      return e.toString();
    }
  }

// ---------------------------------------------------------------------------------------------------------------------------------------------------------------

  // Future getUserData() async {
  //   if (firebaseAuth.currentUser != null) {
  //     DatabaseService databaseService = DatabaseService();

  //     var userData = await databaseService.getUserDataWithUid(
  //         uid: firebaseAuth.currentUser!.uid); // {"email":"ankit@gmail.com"}

  //     print('here user $userData');

  //     return userData;
  //   }
  // }

  // --------------------------------------------------------------------------------------------------------------------

  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF(" ");
      await firebaseAuth.signOut();

      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
