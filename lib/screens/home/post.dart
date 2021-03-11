import 'package:flutter/material.dart';
import 'package:go_camping/services/getData.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_camping/widgets/small_loading.dart';

class Post extends StatefulWidget {
  final String name, distanceInKM;
  final List<String> images;
  final double positive, negative, latitude, longitude;

  Post(
      {this.name,
      this.positive,
      this.latitude,
      this.longitude,
      this.negative,
      this.images,
      this.distanceInKM});

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  GetData getImages = GetData();
  List<String> urls = [];

  @override
  void initState() {
    super.initState();
    getUrls();
  }

  //get a list of urls from images list
  getUrls() async {
    widget.images.forEach((url) async {
      await getImages.getImageURL(url).then((value) => urls.add(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    //image widget
    final List<Widget> imageSliders = urls
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(2.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Image.network(item, fit: BoxFit.cover, width: 1000.0),
                ),
              ),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        elevation: 0,
        backgroundColor: Colors.green[300],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
                child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                imageSliders.isEmpty
                    ? SmallLoading()
                    : CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                        ),
                        items: imageSliders,
                      ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    child: Container(
                      color: Colors.green[300],
                    ),
                  ),
                )
              ],
            )),
          ),
        ],
      ),
    );
  }
}
