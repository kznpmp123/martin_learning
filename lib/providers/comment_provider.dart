import 'package:flutter/material.dart';
import 'package:optimize/models/Comment.dart';
import 'package:optimize/models/User.dart';
import 'package:optimize/network/comment_service.dart';

class CommentProvider with ChangeNotifier {
  List<CommentModel> comments = [];

  Future<void> getAll(String path, int id) async {
    comments.clear();
    var response = await CommentService.getAll(path, id);

    for (var i = 0; i < response["data"].length; i++) {
      CommentModel data = CommentModel(
        id: response["data"][i]["id"],
        user: User(
          id: response["data"][i]["user"]['id'],
          username: response['data'][i]['user']['name'],
          email: response['data'][i]['user']['email'],
        ),
        body: response["data"][i]["body"],
      );
      comments.add(data);
    }
    notifyListeners();
  }

  Future<void> postComment(
      String path, Map<String, String> data, int id) async {
    var response = await CommentService.postComment(path, data, id);

    CommentModel comment = CommentModel(
      id: response["data"]["id"],
      user: User(
        id: response["data"]["user"]['id'],
        username: response['data']['user']['name'],
        email: response['data']['user']['email'],
      ),
      body: response["data"]["body"],
    );

    comments.add(comment);

    notifyListeners();
  }

  Future<void> deleteComment(String path, int id) async {
    var response = await CommentService.deleteComment(path, id);
    if (response == 204) {
      comments.removeWhere((comment) => comment.id == id);
      notifyListeners();
    }
  }
}
