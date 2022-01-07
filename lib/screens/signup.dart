import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeshop/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:coffeshop/screens/login.dart';
import 'package:coffeshop/screens/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  void signUp(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFireStore()})
          .catchError((e) => {Fluttertoast.showToast(msg: e!.message)});
    }
  }

  void postDetailsToFireStore() async {
    // CALLING OUR FIRESTORE
    // CALLING OUR USERMODEL
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    // WRITTING ALL THE VALUES
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = nameController.text;

    // SENDING THESE VALUES TO FIRESTORE
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    // SHOWING TOAST MESSAGE
    Fluttertoast.showToast(msg: "Account Created Successfully");

    //  SAVING LOGIN SESSION
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("email", emailController.text);
    sharedPreferences.setString("name", nameController.text);

    // NAVIGATE TO HOME SCREEN
    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
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
                      'Sign Up',
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
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        nameController.text = value!;
                      },
                      decoration: InputDecoration(labelText: 'Full Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name cannot be empty";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      autofocus: false,
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        emailController.text = value!;
                      },
                      decoration: InputDecoration(labelText: 'Email'),
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
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        passwordController.text = value!;
                      },
                      decoration: InputDecoration(labelText: 'Password'),
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
                    TextFormField(
                      autofocus: false,
                      controller: confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      onSaved: (value) {
                        confirmPasswordController.text = value!;
                      },
                      decoration:
                          InputDecoration(labelText: 'Confirm Password'),
                      validator: (value) {
                        if (confirmPasswordController.text !=
                            passwordController.text) {
                          return "Password does not match";
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
                        onPressed: () => {signUp(context)},
                        child: Text(
                          'Sign Up',
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
                                    builder: (context) => Login()))
                          },
                          child: Text('Already have an account ?',
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
