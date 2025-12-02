import 'package:clean_architecture_example/feature/presentation/bloc/comment_bloc.dart';
import 'package:clean_architecture_example/feature/presentation/pages/comment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'locator.dart';

void main() {
  init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CommentBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Clean Architecture Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const CommentPage(),
      ),
    );
  }
}
