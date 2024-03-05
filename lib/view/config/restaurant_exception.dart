//Special exception for app to avoid unnecessary "Exception:" string in messages
class RestaurantException implements Exception {
  final String message;

  RestaurantException(this.message);

  @override
  String toString() {
    return message;
  }
}
