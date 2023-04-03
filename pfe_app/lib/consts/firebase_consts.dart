import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;

//collections
const usersCollection = "user";
const productsCollection = "products";
const cartCollection = "cart";
const chatCollection = "chats";
const messageCollection = 'messages';
const ordersCollection = "orders";
const bannersCollection = "banners";

