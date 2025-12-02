import 'package:bloc/bloc.dart';
import 'package:clean_architecture_example/feature/presentation/bloc/comment_event.dart';
import 'package:clean_architecture_example/feature/presentation/bloc/comment_state.dart';

import '../../data/exceptions/exception.dart';
import '../../domain/usecases/fetch_comment.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final FetchComments fetchComments;

  CommentBloc(this.fetchComments) : super(const CommentState()) {
    on<FetchCommentsEvent>(_onFetchComments);
  }

  Future<void> _onFetchComments(
    FetchCommentsEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(state.copyWith(status: CommentsStatus.loading, errorMessage: null));

    try {
      final result = await fetchComments.call();
      if (result.isEmpty) {
        emit(state.copyWith(comments: [], status: CommentsStatus.success));
      } else {
        emit(state.copyWith(comments: result, status: CommentsStatus.success));
      }
    } catch (e) {
      String message;
      if (e is ServerException) {
        message = e.message;
      } else if (e is NetworkException) {
        message = e.message;
      } else if (e is DataParsingException) {
        message = e.message;
      } else {
        message = 'An unexpected error occurred: ${e.toString()}';
      }
      emit(state.copyWith(status: CommentsStatus.error, errorMessage: message));
    }
  }
}
