import 'package:flutter/material.dart';
import 'package:lms/core/widgets/custom_image.dart';

import 'package:lms/core/utils/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/parent_flow/data/models/parent_notification_model.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_cubit.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_state.dart';

class NotificationsBottomSheet extends StatefulWidget {
  const NotificationsBottomSheet({super.key});

  @override
  State<NotificationsBottomSheet> createState() =>
      _NotificationsBottomSheetState();
}


class _NotificationsBottomSheetState extends State<NotificationsBottomSheet> {
  @override
  void initState() {
    super.initState();
    context.read<ParentCubit>().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentCubit, ParentState>(
      builder: (context, state) {
        if (state.status == ParentStatus.loading && state.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final notifications = state.notifications;

        return Column(
          children: [
            const Text(
              'الاشعارات',
              style: TextStyle(
                fontSize: 21.44,
                fontWeight: FontWeight.w700,
                color: AppColors.c721D1D,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildNotificationList(notifications),
            ),
          ],
        );
      },
    );
  }


  Widget _buildNotificationList(List<ParentNotificationModel> notifications) {
    if (notifications.isEmpty) {
      return const Center(child: Text('لا توجد اشعارات'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final bool isUnread = !notification.isRead;
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            spacing: 10,
            children: [
              Container(
                width: 42.94,
                height: 42.94,
                decoration: const BoxDecoration(
                  color: AppColors.c721D1D,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 12.27,
                        fontWeight: isUnread ? FontWeight.w700 : FontWeight.w400,
                        color: isUnread ? AppColors.c721D1D : AppColors.c721D1D.withOpacity(0.6),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        notification.message ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9.82,
                          fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
                          color: isUnread ? AppColors.c721D1D : AppColors.c721D1D.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          color: AppColors.c737373.withOpacity(0.7),
        );
      },
    );
  }
}
