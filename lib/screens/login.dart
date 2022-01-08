import 'package:coffeshop/screens/home.dart';
import 'package:coffeshop/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  void logIn(BuildContext context, String email, String password) async {
    if (_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: 'Loading');
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: 'Logged in'),
                saveTosharedPref(),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Home()))
              })
          .catchError((e) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(msg: 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(msg: 'Wrong password provided for that user.');
        } else {
          Fluttertoast.showToast(msg: e.message);
        }
      });
    }
  }

  saveTosharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("email", emailController.text);
    sharedPreferences.setString("name", emailController.text);
  }

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.brown.shade100,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Image.asset('assets/images/logo.png'),
                      height: 250,
                    ),
                    Text(
                      'LogIn',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      autofocus: false,
                      controller: emailController,
                      onSaved: (value) => {emailController.text = value!},
                      decoration: InputDecoration(labelText: 'Email'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email cannot be empty";
                        } else if (!RegExp(
                                "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      autofocus: false,
                      obscureText: true,
                      controller: passwordController,
                      onSaved: (value) => {passwordController.text = value!},
                      decoration: InputDecoration(labelText: 'Password'),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return "Password cannot be empty";
                        } else if (!regex.hasMatch(value)) {
                          return "Please enter valid password (Minimum 6 characters)";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () => {
                          logIn(context, emailController.text,
                              passwordController.text)
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(fontSize: 22),
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signup()))
                          },
                          child: Text('Dont have an account ?',
                              style: TextStyle(
                                  color: Colors.brown.shade600,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
