import 'package:flutter/material.dart';
import 'package:go_camping/initialization/loading.dart';
import 'package:go_camping/services/getData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_camping/widgets/small_loading.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Expanded(child: LocationInformation()),
        ],
      ),
    ));
  }
}

class LocationInformation extends StatelessWidget {
  final GetData getImages = GetData();

  final CollectionReference locations =
      FirebaseFirestore.instance.collection('locations');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: locations.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            List<String> images = List.from(document.data()['images']);

            double percent = (document.data()['positive'].toDouble() /
                    (document.data()['positive'].toDouble() +
                        document.data()['negative'].toDouble())) *
                100;
            String result = percent.toStringAsFixed(0);

            //does not print out urls

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 5,
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: getImages.getImageURL(images[0]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image(
                                  image: NetworkImage(snapshot.data),
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return Text('Could not load image');
                          } else {
                            return SmallLoading();
                          }
                        },
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            document.data()['name'],
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Rating: $result',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
