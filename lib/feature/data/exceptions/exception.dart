// custom exceptions used by data layer
class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error occurred']);
  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error occurred']);
  @override
  String toString() => 'NetworkException: $message';
}

class DataParsingException implements Exception {
  final String message;
  DataParsingException([this.message = 'Failed to parse data']);
  @override
  String toString() => 'DataParsingException: $message';
}
