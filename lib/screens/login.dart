import 'package:coffeshop/screens/home.dart';
import 'package:coffeshop/screens/signup.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.brown.shade100,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: SingleChildScrollView(
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
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(labelText: 'Password'),
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()))
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Signup()))
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
    );
  }
}
