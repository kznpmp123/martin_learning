import 'package:optimize/models/User.dart';

class CommentModel {
  final int id;
  final User user;
  final String body;

  CommentModel({
    required this.id,
    required this.user,
    required this.body,
  });
}
