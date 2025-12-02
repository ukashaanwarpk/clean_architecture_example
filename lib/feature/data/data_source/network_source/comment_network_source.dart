import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:clean_architecture_example/feature/data/models/comment_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/constant.dart';
import '../../exceptions/exception.dart';

abstract class CommentRemoteDataSource {
  /// Fetch comments from remote API
  /// Throws ServerException, NetworkException, DataParsingException
  Future<List<CommentModel>> getComments();
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final http.Client client;
  final Duration timeout;

  CommentRemoteDataSourceImpl({
    required this.client,
    this.timeout = const Duration(seconds: 10),
  });

  @override
  Future<List<CommentModel>> getComments() async {
    try {
      final uri = Uri.parse(commentApi);
      final responseFuture = client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      final response = await responseFuture.timeout(timeout);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body is List) {
          try {
            return body
                .cast<Map<String, dynamic>>()
                .map((json) => CommentModel.fromJson(json))
                .toList();
          } catch (e) {
            throw DataParsingException('Error parsing comment list: $e');
          }
        } else {
          throw DataParsingException('Expected a JSON array for comments.');
        }
      } else {
        throw ServerException(
            'Failed loading comments. HTTP ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw NetworkException('No network connection: $e');
    } on HttpException catch (e) {
      throw NetworkException('HTTP error: $e');
    } on FormatException catch (e) {
      throw DataParsingException('Invalid JSON format: $e');
    } on TimeoutException catch (e) {
      throw NetworkException('Request timed out: $e');
    } catch (e) {
      // Unknown error
      throw ServerException('Unexpected error: $e');
    }
  }
}
