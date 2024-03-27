part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitialState extends NotificationState {
  const NotificationInitialState();
}

//Represents the initial state of the BLoc
class StartUpNotificationState extends NotificationState {
  const StartUpNotificationState();
}

class OrdinaryNotificationState extends NotificationState {
  const OrdinaryNotificationState();
}
