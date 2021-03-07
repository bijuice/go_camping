import 'package:cloud_firestore/cloud_firestore.dart';

//class defines places of interest

class Place {
  String name;
  GeoPoint geoPoint;
  double positive, negative, distance;
  List<String> images;

  Place(
      {this.name,
      this.geoPoint,
      this.distance,
      this.images,
      this.negative,
      this.positive});
}
