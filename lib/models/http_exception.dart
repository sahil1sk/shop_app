
class HttpException implements Exception { // implementing abastraction class
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}