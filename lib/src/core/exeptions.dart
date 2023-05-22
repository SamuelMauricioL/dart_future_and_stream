class CustomException implements Exception {
  final String message;
  const CustomException(this.message);
}

class HttpException implements Exception {
  final String message;
  const HttpException(this.message);
}
