//Model for push notification from Cloud Messaging
class PushNotification {
  final String? title;
  final String? body;

  PushNotification({
    required this.title,
    required this.body,
  });

  @override
  String toString() {
    return "Notification title: $title body: $body";
  }
}
