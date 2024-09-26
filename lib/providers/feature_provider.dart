import 'package:flutter/material.dart';
import 'package:optimize/models/Category.dart';
import 'package:optimize/models/OneZOne.dart';
import 'package:optimize/models/PlusOne.dart';
import 'package:optimize/models/Pn.dart';
import 'package:optimize/network/one_z_one_service.dart';
import 'package:optimize/network/plus_one_service.dart';
import 'package:optimize/network/pn_service.dart';

class FeatureProvider with ChangeNotifier {
  List<OneZOne> ozOnes = [];
  List<Pn> pns = [];
  List<PlusOne> plusOnes = [];

  Future<void> getAll() async {
    ozOnes.clear();
    pns.clear();
    plusOnes.clear();
    var response = await OneZOneService.getAllF();
    for (var i = 0; i < response["data"].length; i++) {
      OneZOne data = OneZOne(
        id: response["data"][i]["id"],
        title: response["data"][i]["title"],
        video: response["data"][i]["video"] ?? "",
        isUtube: response["data"][i]["isYoutube"],
        subtitle: response["data"][i]["subtitle"],
        description: response["data"][i]["description"] ?? "",
        thumbnail: response["data"][i]["thumbnail"] ?? "",
        poster_image: response["data"][i]["poster_image"] ?? "",
        isBooked: response["data"][i]["isBooked"],
        isLiked: response["data"][i]["isLiked"],
        isTipped: response["data"][i]["isTiped"],
        isSub: response["data"][i]["isSubscribed"],
        pdfFiles: [],
        audioFiles: [],
        videoFiles: [],
        posters: [],
      );
      ozOnes.add(data);
    }

    response = await PlusOneService.getAllF();

    for (var i = 0; i < response["data"].length; i++) {
      PlusOne data = PlusOne(
        id: response["data"][i]["id"],
        title: response["data"][i]["title"],
        code: response["data"][i]["code"],
        subtitle: response["data"][i]["subtitle"],
        description: response["data"][i]["description"] ?? "",
        audio: "abc.mp3",
        video: response["data"][i]["video"] ?? "",
        isUtube: response["data"][i]["isYoutube"],
        thumbnail: response["data"][i]["thumbnail"] ?? "",
        isBooked: response["data"][i]["isBooked"],
        isLiked: response["data"][i]["isLiked"],
        isTipped: response["data"][i]["isTiped"],
      );
      plusOnes.add(data);
    }

    response = await PnService.getAllF();

    for (var i = 0; i < response["data"].length; i++) {
      List<Category> categories = [];
      for (var y = 0; y < response["data"][i]["categories"].length; y++) {
        categories.add(Category(
            id: response["data"][i]["categories"][y]["id"],
            name: response["data"][i]["categories"][y]["name"]));
      }
      Pn data = Pn(
          id: response["data"][i]["id"],
          title: response["data"][i]["title"],
          authorName: response["data"][i]["author_name"] ?? "",
          subtitle: response["data"][i]["subtitle"] ?? "",
          description: response["data"][i]["description"] ?? "",
          coverImage: response["data"][i]["cover_image"],
          introVideo: response["data"][i]["intro_video"] ?? "",
          introThumbnail: response["data"][i]["intro_video_thumbnail"] ?? "",
          introDescription: response["data"][i]["intro_description"] ?? "",
          isBooked: response["data"][i]["isBooked"],
          isLiked: response["data"][i]["isLiked"],
          isTipped: response["data"][i]["isTiped"],
          audioFiles: [],
          pdfFiles: [],
          videoFiles: [],
          isSub: false,
          categories: categories);
      pns.add(data);
    }

    notifyListeners();
  }
}
