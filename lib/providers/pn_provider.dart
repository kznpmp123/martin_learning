import 'package:flutter/material.dart';
import 'package:optimize/models/AudioFile.dart';
import 'package:optimize/models/Category.dart';
import 'package:optimize/models/PdfFile.dart';

import 'package:optimize/models/Pn.dart';
import 'package:optimize/models/VideoFile.dart';
import 'package:optimize/network/pn_service.dart';

class PnProvider with ChangeNotifier {
  List<Pn> items = [];
  late Pn item;

  Future<void> getAll(bool sorted) async {
    items.clear();
    var response = await PnService.getAll();

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
          coverImage: response["data"][i]["cover_image"] ?? "",
          introVideo: response["data"][i]["intro_video"] ?? "",
          introThumbnail: response["data"][i]["intro_video_thumbnail"] ?? "",
          introDescription: response["data"][i]["intro_description"] ?? "",
          isBooked: response["data"][i]["isBooked"],
          isLiked: response["data"][i]["isLiked"],
          isTipped: response["data"][i]["isTiped"],
          isSub: response["data"][i]["isSubscribed"],
          pdfFiles: [],
          audioFiles: [],
          videoFiles: [],
          categories: categories);
      items.add(data);
    }

    if (sorted) {
      items = List.from(items.reversed);
    }
    notifyListeners();
  }

  Future<void> getEach(int id) async {
    var response = await PnService.getEach(id);
    List<Category> categories = [];
    List<PdfFile> pdfFiles = [];
    List<AudioFile> audioFiles = [];
    List<VideoFile> videoFiles = [];
    for (var y = 0; y < response["data"]["categories"].length; y++) {
      categories.add(Category(
          id: response["data"]["categories"][y]["id"],
          name: response["data"]["categories"][y]["name"]));
    }

    for (var y = 0; y < response["data"]["audios"].length; y++) {
      audioFiles.add(AudioFile(
          id: response["data"]["audios"][y]["id"],
          name: response["data"]["audios"][y]["title"] ?? "",
          thumbnail: response["data"]["audios"][y]["thumbnail"] ?? "",
          url: response["data"]["audios"][y]["audio"]));
    }

    for (var y = 0; y < response["data"]["videos"].length; y++) {
      videoFiles.add(VideoFile(
          id: response["data"]["videos"][y]["id"],
          isYouTube: response["data"]["videos"][y]["is_youtube"],
          name: response["data"]["videos"][y]["title"],
          subTitle: response["data"]["videos"][y]["subtitle"] ?? "",
          thumbnail: response["data"]["videos"][y]["thumbnail"],
          url: response["data"]["videos"][y]["video"]));
    }

    for (var y = 0; y < response["data"]["workbooks"].length; y++) {
      pdfFiles.add(PdfFile(
          id: response["data"]["workbooks"][y]["id"],
          name: response["data"]["workbooks"][y]["title"],
          url: response["data"]["workbooks"][y]["work_book"]));
    }

    item = Pn(
        id: response["data"]["id"],
        title:
            response["data"]["title"] ?? "",
        authorName: response["data"]["author_name"] ?? "",
        subtitle: response["data"]["subtitle"] ?? "",
        description: response["data"]["description"] ?? "",
        coverImage: response["data"]["cover_image"] ?? "",
        introVideo: response["data"]["intro_video"] ?? "",
        introThumbnail: response["data"]["intro_video_thumbnail"] ?? "",
        introDescription: response["data"]["intro_description"] ?? "",
        isBooked: response["data"]["isBooked"],
        isLiked: response["data"]["isLiked"],
        isTipped: response["data"]["isTiped"],
        isSub: response["data"]["isSubscribed"] ?? false,
        pdfFiles: pdfFiles,
        audioFiles: audioFiles,
        videoFiles: videoFiles,
        categories: categories);

    // for detail screen when it reached from my list
    if (items.isEmpty) {
      items.add(item);
    }

    notifyListeners();
  }

  Future<void> markData(String type, int id, int value) async {
    var response = await PnService.markData(type, id, value);
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
    var response = await PnService.subscribeCourse(id);
    print(response);
  }
}
