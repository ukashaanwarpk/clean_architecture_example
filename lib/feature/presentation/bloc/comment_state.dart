import 'package:equatable/equatable.dart';

import '../../domain/entities/comment.dart';

enum CommentsStatus { initial, loading, success, error }

class CommentState extends Equatable {
  final List<Comment> comments;
  final CommentsStatus status;
  final String? errorMessage;

  const CommentState({
    this.comments = const [],
    this.status = CommentsStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [comments, status, errorMessage];

  CommentState copyWith({
    List<Comment>? comments,
    CommentsStatus? status,
    String? errorMessage,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
