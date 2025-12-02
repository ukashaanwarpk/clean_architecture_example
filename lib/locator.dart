// lib/locator.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'feature/data/data_source/network_source/comment_network_source.dart';
import 'feature/data/repositories/comment_repository_impl.dart';
import 'feature/domain/repository/comment_repository.dart';

import 'feature/domain/usecases/fetch_comment.dart';
import 'feature/presentation/bloc/comment_bloc.dart';

final sl = GetIt.instance;

void init() {
  // External
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Data source
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSourceImpl(client: sl<http.Client>()),
  );

  // Repository - register under the interface type CommentRepository
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(sl<CommentRemoteDataSource>()),
  );

  // Use case
  sl.registerLazySingleton<FetchComments>(
    () => FetchComments(sl<CommentRepository>()),
  );

  // Bloc - factory so each widget gets its own instance
  sl.registerFactory<CommentBloc>(() => CommentBloc(sl<FetchComments>()));
}
