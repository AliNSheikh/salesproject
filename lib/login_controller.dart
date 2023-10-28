import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salesproject/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginController {
//   String email;
//   String password;
//   LoginController({
//     required this.email,
//     required this.password,
// });

  static bool isEmailValid(String email) {
    // Regular expression pattern to validate email addresses
    final emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$');

    return emailRegex.hasMatch(email);
  }
  static UserModel? loggedUser;

  static Future<String> login(String email, String password) async {
    print('from controller');
    print(email);
    print(password);
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return 'admin';
    } catch (e) {
      print('Error during sign-in: ${e.toString()}');
      var user = await FirebaseFirestore.instance.collection('users').where('email',isEqualTo: email).where('password',isEqualTo: password).get();
      if(user.docs.isNotEmpty){
        loggedUser=UserModel.fromMap(user.docs[0].data());
        return 'user';
      }
      return 'notRegistered';
    }
  }
}
