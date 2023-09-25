import '../../models/notification/notification.dart';
import '../../models/notification/notification1.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class ListNotificationSuccess extends NotificationState {
  final List<NotificationModel>? listNotification;
  ListNotificationSuccess({required this.listNotification});
}

class NotificationFailure extends NotificationState {
  final String errorMessage;
  NotificationFailure({required this.errorMessage});
}
