import '../entities/comment.dart';
import '../repository/comment_repository.dart';

class FetchComments {
  final CommentRepository repository;

  FetchComments(this.repository);

  Future<List<Comment>> call() {
    return repository.fetchComment();
  }
}
