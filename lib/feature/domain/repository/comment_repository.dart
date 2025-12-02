import 'package:clean_architecture_example/feature/domain/entities/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> fetchComment();
}
