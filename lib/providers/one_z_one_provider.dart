import 'package:flutter/material.dart';
import 'package:optimize/models/AudioFile.dart';
import 'package:optimize/models/OneZOne.dart';
import 'package:optimize/models/PdfFile.dart';
import 'package:optimize/models/Poster.dart';
import 'package:optimize/models/VideoFile.dart';
import 'package:optimize/network/one_z_one_service.dart';

class OneZOneProvider with ChangeNotifier {
  List<OneZOne> items = [];
  late OneZOne item;

  Future<void> getAll(bool sorted) async {
    items.clear();
    var response = await OneZOneService.getAll();

    for (var i = 0; i < response["data"].length; i++) {
      OneZOne data = OneZOne(
        id: response["data"][i]["id"],
        title: response["data"][i]["title"],
        video: response["data"][i]["video"] ?? "",
        isUtube: response["data"][i]["isYoutube"],
        subtitle: response["data"][i]["subtitle"] ?? "",
        description: response["data"][i]["description"] ?? "",
        thumbnail: response["data"][i]["thumbnail"] ?? "",
        poster_image: response["data"][i]["poster_image"] ?? "",
        isBooked: response["data"][i]["isBooked"],
        isLiked: response["data"][i]["isLiked"],
        isTipped: response["data"][i]["isTiped"],
        isSub: response["data"][i]["isSubscribed"] ?? "",
        pdfFiles: [],
        audioFiles: [],
        videoFiles: [],
        posters: [],
      );
      items.add(data);
    }

    if (sorted) {
      items = List.from(items.reversed);
    }

    notifyListeners();
  }

  Future<void> getEach(int id) async {
    print("OneZoneProvider->getEach $id");
    var response = await OneZOneService.getEach(id);

    List<PdfFile> pdfFiles = [];
    print("gettingPdfFiles");
    for (var y = 0; y < response["data"]["workbooks"].length; y++) {
      pdfFiles.add(PdfFile(
          id: response["data"]["workbooks"][y]["id"],
          name: response["data"]["workbooks"][y]["title"],
          url: response["data"]["workbooks"][y]["work_book"])
      );
    }
    print(pdfFiles);


    List<Poster> posters = [];
    for (var y = 0; y < response["data"]["posters"].length; y++) {
      posters.add(
          Poster(
            id: response["data"]["posters"][y]["id"],
            name: response["data"]["posters"][y]["title"],
            url: response["data"]["posters"][y]["poster"]
          )
      );
    }

    print("gettingAudioFiles");
    List<AudioFile> audioFiles = [];
    for (var y = 0; y < response["data"]["audios"].length; y++) {
      audioFiles.add(AudioFile(
          id: response["data"]["audios"][y]["id"],
          name: response["data"]["audios"][y]["title"] ,
          thumbnail: response["data"]["audios"][y]["thumbnail"] ?? "",
          url: response["data"]["audios"][y]["audio"]));
    }
    print(audioFiles);
    //print(audioFiles.first.thumbnail);

    print("Getting videoFiles");
    List<VideoFile> videoFiles = [];
    for (var y = 0; y < response["data"]["videos"].length; y++) {
      print(response["data"]["videos"][y]["is_youtube"]);
      videoFiles.add(VideoFile(
          id: response["data"]["videos"][y]["id"],
          isYouTube: response["data"]["videos"][y]["is_youtube"],
          name: response["data"]["videos"][y]["title"],
          subTitle: response["data"]["videos"][y]["subtitle"] ?? "",
          thumbnail: response["data"]["videos"][y]["thumbnail"] ?? "",
          url: response["data"]["videos"][y]["video"] ?? ""));
    }
    print(videoFiles);

    item = OneZOne(
      id: response["data"]["id"],
      title: response["data"]["title"] ?? "title",
      subtitle: response["data"]["subtitle"] ?? "subtitle",
      video: response["data"]["video"] ?? "",
      isUtube: response["data"]["isYoutube"],
      description: response["data"]["description"] ?? "",
      thumbnail: response["data"]["thumbnail"] ?? "",
      poster_image: response["data"]["poster_image"] ?? "",
      isBooked: response["data"]["isBooked"],
      isLiked: response["data"]["isLiked"],
      isTipped: response["data"]["isTiped"],
      isSub: response["data"]["isSubscribed"],
      pdfFiles: pdfFiles,
      audioFiles: audioFiles,
      videoFiles: videoFiles,
      posters: posters,
    );
    print(item);
    // for detail screen when it reached from my list
    if (items.isEmpty) {
      items.add(item);
    }
    notifyListeners();
  }


  Future<void> markData(String type, int id, int value) async {
    var response = await OneZOneService.markData(type, id, value);
    item = items.firstWhere((element) => element.id == id);
    if (type == "like") {
      item.isLiked = value == 1 ? true : false;
    } else if (type == "bookmark") {
      item.isBooked = value == 1 ? true : false;
    } else if (type == "tip") {
      item.isTipped = value == 1 ? true : false;
    }
    notifyListeners();
  }

  Future<void> subscribeCourse(int id) async {
    var response = await OneZOneService.subscribeCourse(id);
    print(response);
  }
}
