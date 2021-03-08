import 'package:cloud_firestore/cloud_firestore.dart';

//class defines places of interest

class Place {
  String name;
  GeoPoint geoPoint;
  int positive, negative;
  List<String> images;

  Place({this.name, this.geoPoint, this.images, this.negative, this.positive});
}
