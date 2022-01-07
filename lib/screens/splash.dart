import 'package:coffeshop/screens/login.dart';
import 'package:coffeshop/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String loggedInUserEmail = '';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      print("WidgetsBinding");
      Future.delayed(Duration(seconds: 5), () {
        print('yo hey');
        getValidationData().whenComplete(() async => {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          (loggedInUserEmail == '' ? Login() : Home())))
            });
      });
    });
    super.initState();
  }

  Future getValidationData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    setState(() {
      loggedInUserEmail = obtainedEmail!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
