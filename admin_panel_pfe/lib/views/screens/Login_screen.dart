import 'package:admin_panel_pfe/services/firebase_service.dart';
import 'package:admin_panel_pfe/views/screens/Home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  FirebaseServices _services = FirebaseServices();
  String? username;
  String? password;

  @override
  Widget build(BuildContext context) {
    Future<void> _login() async {
      _services.getAdminCredentials().then(
        (value) {
          value.docs.forEach((doc) async {
            if (doc.get('username') == username) {
              if (doc.get('password') == password) {
                UserCredential userCredential =
                    await FirebaseAuth.instance.signInAnonymously();
                CircularProgressIndicator();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen()));
                return;
              } else {
                _showMyDialog(title: 'Login', message: 'Login Failed.');
              }
            } else {
              _showMyDialog(
                  title: 'Invalid Username',
                  message: 'Username you entered is not valid.');
            }
          });
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(250, 207, 2, 207),
        elevation: 0.0,
        title: Center(
          child: Text(
            'Marque blanche admin panel',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _initialization,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Connection failed'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(250, 207, 2, 207), Colors.white],
                  stops: [0.0, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment(0.0, 0.0),
                ),
              ),
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  child: Card(
                    elevation: 6,
                    shape: Border.all(
                        color: Color.fromARGB(255, 213, 10, 231), width: 2),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'app_logo.png',
                                      width: 60,
                                      height: 60,
                                    ),
                                    Text(
                                      'ADMIN APP',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 13),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter your username';
                                        }
                                        setState(() {
                                          username = value;
                                        });
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.person),
                                          labelText: 'User Name',
                                          contentPadding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 2))),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter your valid password';
                                        }
                                        setState(() {
                                          password = value;
                                        });
                                        return null;
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.vpn_key_off_rounded),
                                          labelText: 'Password',
                                          contentPadding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 2))),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: Color.fromARGB(
                                              255, 213, 10, 231)),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _login();
                                        }
                                      },
                                      child: Text(
                                        'Login',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<void> _showMyDialog({title, message}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                Text('Please try again'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
