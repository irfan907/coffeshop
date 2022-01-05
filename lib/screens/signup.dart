import 'package:flutter/material.dart';
import 'package:coffeshop/screens/login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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
                    decoration: InputDecoration(labelText: 'Full Name'),
                  ),
                  TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
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
                      onPressed: () => {},
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()))
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
    );
  }
}
