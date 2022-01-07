import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffeshop/screens/login.dart';
import 'package:coffeshop/models/user_model.dart';
import 'package:coffeshop/models/product_model.dart';
import 'package:coffeshop/screens/home.dart';
import 'package:coffeshop/screens/upload_image.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController volumeController = new TextEditingController();

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

  final Storage storage = new Storage();
  var path;
  var fileName;

  Future pickImage(BuildContext context) async {
    // SELLECTING FILE
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );
    if (results == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No file Selected!"),
        ),
      );
      return null;
    }
    setState(() {
      path = results.files.single.path;
      fileName = results.files.single.name;
    });

    // CALLING UPLOAD FUNCTION
    storage.uploadFile(path, fileName);
  }

  void upload(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // upload product here
      uploadProduct();
    }
  }

  void uploadProduct() async {
    // CALLING OUR FIRESTORE
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    ProductModel productModel = ProductModel();

    // WRITTING ALL THE VALUES
    productModel.name = nameController.text;
    productModel.price = priceController.text;
    productModel.description = descriptionController.text;
    productModel.volume = volumeController.text;
    productModel.uid = loggedInUser.uid;
    productModel.picture = fileName;

    // SENDING THESE VALUES TO FIRESTORE
    await firebaseFirestore
        .collection("products")
        .doc(user!.uid)
        .set(productModel.toMap())
        .then((value) =>
            {Fluttertoast.showToast(msg: "Product Uploaded Successfully")})
        .catchError((e) => {Fluttertoast.showToast(msg: e!.message)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Product'),
        centerTitle: true,
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
        color: Colors.brown.shade100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: Card(
                    color: Colors.brown.shade200,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 40, bottom: 40, left: 20, right: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              'Enter Product Details',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown.shade900),
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
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Product Name cannot be empty";
                                }
                                return null;
                              },
                              decoration:
                                  InputDecoration(labelText: 'Product Name'),
                            ),
                            TextFormField(
                              autofocus: false,
                              controller: priceController,
                              textInputAction: TextInputAction.next,
                              onSaved: (value) {
                                priceController.text = value!;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Price cannot be empty";
                                }
                                return null;
                              },
                              decoration:
                                  InputDecoration(labelText: 'Product Price'),
                            ),
                            TextFormField(
                              autofocus: false,
                              controller: descriptionController,
                              textInputAction: TextInputAction.next,
                              onSaved: (value) {
                                descriptionController.text = value!;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Description cannot be empty";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Product Description'),
                            ),
                            TextFormField(
                              autofocus: false,
                              controller: volumeController,
                              textInputAction: TextInputAction.done,
                              onSaved: (value) {
                                volumeController.text = value!;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Volume cannot be empty";
                                }
                                return null;
                              },
                              decoration: InputDecoration(labelText: 'Volume'),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  pickImage(context);
                                },
                                child: Text('Choose image')),
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () => {upload(context)},
                                child: Text(
                                  'Upload Product',
                                  style: TextStyle(fontSize: 22),
                                ),
                                style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
