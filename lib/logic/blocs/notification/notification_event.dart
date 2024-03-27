part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class InitializeNotificationEvent extends NotificationEvent {
  const InitializeNotificationEvent();
}

class NotificationCarriedEvent extends NotificationEvent {
  //carries the payload sent for notification
  final String payload;

  const NotificationCarriedEvent(this.payload);

  @override
  List<Object> get props => [payload];
}

class NotificationErrorEvent extends NotificationEvent {
  final String message;

  const NotificationErrorEvent(this.message);

  @override
  List<Object> get props => [message];
}
