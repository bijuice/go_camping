import 'package:flutter/material.dart';
import 'package:go_camping/initialization/loading.dart';
import 'package:go_camping/screens/home/post.dart';
import 'package:go_camping/services/getData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_camping/widgets/small_loading.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.green[300],
      body: Column(
        children: [
          Expanded(child: LocationInformation()),
        ],
      ),
    ));
  }
}

class LocationInformation extends StatefulWidget {
  @override
  _LocationInformationState createState() => _LocationInformationState();
}

class _LocationInformationState extends State<LocationInformation> {
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  final GetData getImages = GetData();

  final CollectionReference locations =
      FirebaseFirestore.instance.collection('locations');

  String latt = '0';
  String long = '0';

  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latt = '${position.latitude}';
      long = '${position.longitude}';
    });
  }

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
            //fetch urls from firebase
            List<String> images = List.from(document.data()['images']);

            //calculate ratings
            double percent = (document.data()['positive'].toDouble() /
                    (document.data()['positive'].toDouble() +
                        document.data()['negative'].toDouble())) *
                100;
            String result = percent.toStringAsFixed(0);

            //get distances
            double locLatt = document.data()['latitude'].toDouble();
            double locLong = document.data()['longitude'].toDouble();

            String distanceInKM = '';

            distanceInKM = (Geolocator.distanceBetween(double.parse(latt),
                        double.parse(long), locLatt, locLong) /
                    1000)
                .toStringAsFixed(0);

            //navigate to post
            void goToPost(context) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Post(
                    name: document.data()['name'],
                    positive: document.data()['positive'].toDouble(),
                    negative: document.data()['negative'].toDouble(),
                    images: images,
                    latitude: document.data()['latitude'].toDouble(),
                    longitude: document.data()['longitude'].toDouble(),
                    distanceInKM: distanceInKM);
              }));
            }

            //build list view
            return GestureDetector(
              onTap: () {
                goToPost(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          FutureBuilder(
                            future: getImages.getImageURL(images[0]),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  child: Image(
                                    image: NetworkImage(snapshot.data),
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
                                    fontSize: 14,
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
                                distanceInKM != null
                                    ? 'Distance: $distanceInKM Kilometers'
                                    : '',
                                style: TextStyle(
                                    fontSize: 14,
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
