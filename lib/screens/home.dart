import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeshop/screens/login.dart';
import 'package:coffeshop/screens/upload.dart';
import 'package:coffeshop/screens/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffeshop/screens/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Storage storage = Storage();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  void logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('email');
    Fluttertoast.showToast(msg: "Logout Successfully");
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade900,
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/logo.png'),
                      maxRadius: 40,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '${loggedInUser.name}',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              leading: Icon(Icons.home),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            ListTile(
              title: const Text('Upload Product'),
              leading: Icon(Icons.cloud_upload),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Upload()));
              },
            ),
            ListTile(
              title: const Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                logOut(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(),
                  image: DecorationImage(
                      image: AssetImage('assets/images/home-background.png'),
                      fit: BoxFit.cover)),
              child: Center(
                child: Text(
                  'Coffee Shop',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.brown.shade900,
                  // borderRadius: new BorderRadius.only(
                  //   topLeft: const Radius.circular(40.0),
                  //   topRight: const Radius.circular(40.0),
                  // )
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('products')
                                  .where('uid',
                                      isEqualTo: this.loggedInUser.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                return GridView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 200,
                                            childAspectRatio: 2 / 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      DocumentSnapshot product =
                                          snapshot.data!.docs[index];
                                      return Container(
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Product(
                                                            name:
                                                                product['name'],
                                                            price: product[
                                                                'price'],
                                                            description: product[
                                                                'description'],
                                                            volume: product[
                                                                'volume'],
                                                            picture: product[
                                                                'picture'])));
                                          },
                                          child: Card(
                                            elevation: 5,
                                            color: Colors.brown.shade400,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                FutureBuilder(
                                                  future: storage.downloadURL(
                                                      product['picture']),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<String>
                                                              snapshot) {
                                                    if (snapshot.connectionState ==
                                                            ConnectionState
                                                                .done &&
                                                        snapshot.hasData) {
                                                      return Container(
                                                        height: 130,
                                                        child: Image.network(
                                                          snapshot.data!,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      );
                                                    }
                                                    if (snapshot.connectionState ==
                                                            ConnectionState
                                                                .waiting ||
                                                        !snapshot.hasData) {
                                                      return CircularProgressIndicator();
                                                    }
                                                    return Container();
                                                  },
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 9),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            product['name'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white70,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            '\$' +
                                                                product[
                                                                    'price'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .brown
                                                                    .shade900,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
