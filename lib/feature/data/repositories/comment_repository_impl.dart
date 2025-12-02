import 'package:clean_architecture_example/feature/domain/entities/comment.dart';
import 'package:clean_architecture_example/feature/domain/repository/comment_repository.dart';

import '../data_source/network_source/comment_network_source.dart';
import '../models/comment_model.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  CommentRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Comment>> fetchComment() async {
    // Keep repository simple: just forward remote results and keep model->entity mapping explicit.
    final List<CommentModel> models = await remoteDataSource.getComments();
    // map models to domain entities (CommentModel already extends Comment, but mapping is explicit)
    return models.map<Comment>((m) => Comment(
      postId: m.postId,
      id: m.id,
      name: m.name,
      email: m.email,
      body: m.body,
    )).toList();
  }
}
