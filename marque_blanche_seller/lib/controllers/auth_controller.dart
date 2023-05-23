import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:marque_blanche_seller/views/auth_screen/login_screen.dart';
import 'package:marque_blanche_seller/views/home_screen/home.dart';

import '../const/const.dart';

class AuthController extends GetxController {
  var isloading = false.obs;
 
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

 
  //login method
  Future<void> loginMethod({required BuildContext context}) async {
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final User? user = userCredential.user;
      if (user != null) {
        final DocumentSnapshot vendorDoc = await FirebaseFirestore.instance
            .collection('vendors')
            .doc(user.uid)
            .get();

        if (vendorDoc.exists) {
          final bool accountVerified = vendorDoc['account_verified'];

          if (accountVerified) {
            // Account is active, proceed to home screen
            Get.offAll(() => const Home());
          } else {
            // Account is inactive, display error message
            // ignore: use_build_context_synchronously
            VxToast.show(context,
                msg:
                    'Your account is desactivated. Please contact the administration.');

            // Clear email and password fields
            emailController.clear();
            passwordController.clear();
          }
        } else {
          // Vendor document does not exist
          // ignore: use_build_context_synchronously
          VxToast.show(context, msg: 'Vendor not found.');
        }
      }
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  //signout method
  signoutMethod(context) async {
    try {
      await auth.signOut();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  forgetPassword({email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }
}
