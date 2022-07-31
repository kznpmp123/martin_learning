import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:optimize/models/BlogModel.dart';
class BlogProvider with ChangeNotifier {
  List<BlogModel> blogs = [];
  bool isExisted = true;
  var imageUrl = 'https://mar-thin.com/wp-json/wp/v2/media';
  Future<void> getAll(int page) async {
    if (page==1){
      blogs.clear();
    }
    BaseOptions options = BaseOptions(
      // http://52.47.68.101/wp/wp-json/wp/v2/posts?_embed&page=1
      //baseUrl: "https://mar-thin.com/wp-json/wp/v2/",
      baseUrl: "http://52.47.68.101/wp/wp-json/wp/v2/",
    );
    Dio dio = Dio(options);
    Response response = await dio.get('posts?_embed&page=${page.toString()}');
    var data = response.data;

    for (int k = 0; k < data.length; k++) {

      String image =
          'https://www.elegantthemes.com/blog/wp-content/uploads/2019/04/change-wordpress-thumbnail-size-featured-image.jpg';

      blogs.add(BlogModel(
          id: data[k]["id"],
          title: data[k]["title"]["rendered"],
          content: data[k]["content"]["rendered"],
          image: data[k]["_embedded"]["wp:featuredmedia"][0]["source_url"]
      ));

    }
    notifyListeners();
    /*
    if (page==1){
      blogs.clear();
    }
    for (int k = 0; k < data.length; k++) {

      String image =
          'https://www.elegantthemes.com/blog/wp-content/uploads/2019/04/change-wordpress-thumbnail-size-featured-image.jpg';
      if (data[k]["featured_media"] != 0) {
        Response imageResponse = await dio
            .get(imageUrl + "/" + data[k]["featured_media"].toString());
        var imageData = imageResponse.data;
        image = imageData["source_url"];
      }


      blogs.add(BlogModel(
          id: data[k]["id"],
          title: data[k]["title"]["rendered"],
          content: data[k]["content"]["rendered"],
          image: image
      ));

    }

     */
    if (data.length == 0) {
      isExisted = true;
    }

    notifyListeners();
  }
}
