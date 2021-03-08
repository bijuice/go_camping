import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_camping/initialization/loading.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: LocationInformation(),
    ));
  }
}

class LocationInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference locations =
        FirebaseFirestore.instance.collection('locations');

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
            return Container(
              decoration: BoxDecoration(border: Border.all()),
              child: new ListTile(
                title: new Text(document.data()['name']),
                subtitle: new Text(document.data()['positive'].toString()),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
