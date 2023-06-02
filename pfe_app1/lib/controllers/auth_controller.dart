import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pfe_app/consts/consts.dart';
import 'package:pfe_app/utlis/show_otp_methods.dart';
import 'package:pfe_app/utlis/show_snack_bar.dart';

class AuthController extends GetxController {
  var isloading = false.obs;
  //textcontrollers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  Rx<User?> currentUser = Rx<User?>(null);

  // AuthController(FirebaseAuth instance);

  //login method with email and password
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      String? token = await userCredential.user?.getIdToken();
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: "Please enter a valid email and password");
    }
    return userCredential;
  }

  //login method with phone number
  Future<void> phoneSignIn(
    BuildContext context,
    String phoneNumber,
  ) async {
    TextEditingController codeController = TextEditingController();
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        showSnackBar(context, e.message!);
      },
      codeSent: ((String verificationId, forceResendingToken) async {
        showOTPDialog(
          context: context,
          codeController: codeController,
          onPressed: () async {
            PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId,
              smsCode: codeController.text.trim(),
            );
            await auth.signInWithCredential(credential);
            Navigator.of(context).pop();
          },
        );
      }),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await auth.signInWithCredential(credential);

        // if (userCredential.user != null ) {
        //   if (userCredential.additionalUserInfo!.isNewUser) {

        //   }
        // }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  //signup method
  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;

    if (!isValidEmail(email)) {
      VxToast.show(context, msg: 'Please enter a valid email address.');
    }

    try {
      userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      currentUser.value = userCredential.user;

      await storeUserData(
        email: email,
        password: password,
        name: nameController.text,
      );

      VxToast.show(context, msg: 'User created successfully');
    } catch (e) {
      VxToast.show(context, msg: 'e.toString()');
    }

    return userCredential;
  }

// Email format validation using regular expression
  bool isValidEmail(String email) {
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z\d-]+(\.[a-zA-Z\d-]+)*\.[a-zA-Z\d-]+$');
    return emailRegex.hasMatch(email);
  }

  //storing data method
  storeUserData({name, password, email}) async {
    DocumentReference store =
        firestore.collection(usersCollection).doc(currentUser.value!.uid);
    store.set({
      'name': name,
      'email': email,
      'password': password,
      'imageUrl': "",
      "id": currentUser.value!.uid,
      "cart_count": "00",
      "wishlist_count": "00",
      "order_count": "00",
    });
  }

  //signout method
  signoutMethod(context) async {
    try {
      await auth.signOut();
      isloading(false);
      emailController.clear();
      passwordController.clear();
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
