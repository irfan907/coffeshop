import 'package:coffeshop/screens/upload_image.dart';
import 'package:flutter/material.dart';

class Product extends StatelessWidget {
  final String name, price, description, volume, picture;
  Product(
      {Key? key,
      required this.name,
      required this.price,
      required this.description,
      required this.volume,
      required this.picture})
      : super(key: key);
  Storage storage = Storage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.brown.shade400,
            ),
            child: FutureBuilder(
              future: storage.downloadURL(picture),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Container(
                    height: 130,
                    child: Image.network(
                      snapshot.data!,
                      fit: BoxFit.contain,
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Container();
              },
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.brown.shade900,
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$name',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$' + price,
                          style: TextStyle(
                              color: Colors.brown.shade200,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white60),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            description,
                            style:
                                TextStyle(color: Colors.white60, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text(
                          'Volume:',
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '$volume oz',
                          style: TextStyle(
                              color: Colors.brown.shade300,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
