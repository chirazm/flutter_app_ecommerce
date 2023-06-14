import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pfe_app/consts/consts.dart';

class AuthController extends GetxController {
  var isloading = false.obs;
  //textcontrollers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  Rx<User?> currentUser = Rx<User?>(null);

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

  // signup method
  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;

    if (!isValidEmail(email)) {
      VxToast.show(context, msg: 'Please enter a valid email address.');
      return null;
    }

    try {
      final existingUser = await auth.fetchSignInMethodsForEmail(email);
      if (existingUser.isNotEmpty) {
        VxToast.show(context,
            msg: 'Email already exists. Please try another email.');
        return null;
      }

      userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential != null && userCredential.user != null) {
        currentUser.value = userCredential.user!;

        await storeUserData(
          email: email,
          password: password,
          name: nameController.text,
        );

        VxToast.show(context, msg: 'User created successfully');
      }
    } catch (e) {
      print(e.toString());
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
