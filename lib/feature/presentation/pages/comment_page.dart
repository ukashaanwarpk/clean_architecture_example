import 'package:clean_architecture_example/feature/presentation/bloc/comment_bloc.dart';
import 'package:clean_architecture_example/feature/presentation/bloc/comment_event.dart';
import 'package:clean_architecture_example/feature/presentation/bloc/comment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(FetchCommentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: BlocBuilder<CommentBloc, CommentState>(
        builder: (context, state) {
          switch (state.status) {
            case CommentsStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case CommentsStatus.error:
              return _ErrorView(
                message: state.errorMessage ?? 'Something went wrong',
                onRetry: () => context.read<CommentBloc>().add(FetchCommentsEvent()),
              );
            case CommentsStatus.success:
              if (state.comments.isEmpty) {
                return const Center(child: Text('No comments found.'));
              }
              return ListView.separated(
                itemCount: state.comments.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final comment = state.comments[index];
                  return ListTile(
                    title: Text(comment.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(comment.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Text('#${comment.postId}'),
                    isThreeLine: true,
                  );
                },
              );
            case CommentsStatus.initial:
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
