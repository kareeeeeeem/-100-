import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/features/son_flow/home/presentation/manager/notifications_cubit.dart'; // تأكد من المسار
import 'package:lms/features/son_flow/login/data/model/notifications_response_model.dart';

class NotificationsBottomSheet extends StatefulWidget {
  const NotificationsBottomSheet({super.key});

  @override
  State<NotificationsBottomSheet> createState() => _NotificationsBottomSheetState();
}

class _NotificationsBottomSheetState extends State<NotificationsBottomSheet> {
  @override
  void initState() {
    super.initState();
    // استدعاء البيانات عند فتح الـ BottomSheet
    context.read<NotificationsCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        height: MediaQuery.of(context).size.height * 0.8, // تحديد ارتفاع مناسب
        child: Column(
          children: [
            const Text(
              'الإشعارات',
              style: TextStyle(
                fontSize: 21.44,
                fontWeight: FontWeight.w700,
                color: AppColors.c1E1E1E,
              ),
            ),
            const TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.black,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: 'الكل'),
                Tab(text: 'غير مقروءة'),
                Tab(text: 'مقروءة'),
              ],
            ),
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NotificationsSuccess) {
                    return TabBarView(
                      children: [
                        _buildNotificationsList(state.allNotifications),
                        _buildNotificationsList(state.unreadNotifications),
                        _buildNotificationsList(state.readNotifications),
                      ],
                    );
                  } else if (state is NotificationsError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationItemModel> notifications) {
    if (notifications.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<NotificationsCubit>().fetchNotifications(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: const Center(child: Text('لا توجد إشعارات حالياً')),
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => context.read<NotificationsCubit>().fetchNotifications(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => Divider(
          color: AppColors.c737373.withValues(alpha: 0.7),
        ),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return InkWell(
            onTap: () {
              if (item.isRead == false) {
                context.read<NotificationsCubit>().markAsRead(int.parse(item.id.toString()));
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صورة المرسل أو أيقونة افتراضية
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 21.5,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: item.senderImage != null 
                            ? NetworkImage(item.senderImage!) 
                            : null,
                        child: item.senderImage == null ? const Icon(Icons.notifications) : null,
                      ),
                      if (item.isRead == false)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title ?? 'بدون عنوان',
                          style: TextStyle(
                            fontSize: 12.27,
                            fontWeight: item.isRead == false ? FontWeight.bold : FontWeight.w600,
                            color: AppColors.c1E1E1E,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.message ?? '',
                          style: const TextStyle(
                            fontSize: 9.82,
                            fontWeight: FontWeight.w400,
                            color: AppColors.c1E1E1E,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.createdAt ?? '',
                          style: TextStyle(fontSize: 8, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}