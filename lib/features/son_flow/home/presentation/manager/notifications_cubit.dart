import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';
import 'package:lms/features/son_flow/login/data/model/notifications_response_model.dart';

// الحالات (States)
abstract class NotificationsState {}
class NotificationsInitial extends NotificationsState {}
class NotificationsLoading extends NotificationsState {}
class NotificationsSuccess extends NotificationsState {
  final List<NotificationItemModel> allNotifications;
  final List<NotificationItemModel> readNotifications;
  final List<NotificationItemModel> unreadNotifications;
  NotificationsSuccess(this.allNotifications, this.readNotifications, this.unreadNotifications);
}
class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message);
}

// الـ Cubit
class NotificationsCubit extends Cubit<NotificationsState> {
  final HomeRepository homeRepository;
  NotificationsCubit(this.homeRepository) : super(NotificationsInitial());

  // داخل NotificationsCubit
Future<void> fetchNotifications() async {
  emit(NotificationsLoading());
  final result = await homeRepository.getNotifications();

  // جرب الوصول للمتغيرات مباشرة (تأكد من مسمياتها في ملف result.dart)
  if (result.isSuccess && result.data != null) {
      final all = result.data!.data ?? [];
      final read = all.where((n) => n.isRead == true).toList();
      final unread = all.where((n) => n.isRead == false).toList();
      emit(NotificationsSuccess(all, read, unread));
  } else {
      // إذا كان المتغير اسمه failure وليس error
      emit(NotificationsError(result.failure?.message ?? "حدث خطأ ما"));
  }
}

Future<void> markAsRead(int id) async {
  final result = await homeRepository.markNotificationAsRead(id);
  if (result.isSuccess) {
    // تحديث القائمة بعد التحويل لمقروء
    fetchNotifications();
  }
}
}