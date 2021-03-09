import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class GetData {
  //get image urls
  Future getImageURL(url) async {
    String s = await firebase_storage.FirebaseStorage.instance
        .ref(url)
        .getDownloadURL();

    return s;
  }

  //get location data
  Future<CollectionReference> getLocationData() async {
    CollectionReference locations =
        FirebaseFirestore.instance.collection('locations');

    return locations;
  }
}
