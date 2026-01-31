import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_cubit.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_state.dart';

class NotificationsBottomSheet extends StatefulWidget {
  const NotificationsBottomSheet({super.key});

  @override
  State<NotificationsBottomSheet> createState() =>
      _NotificationsBottomSheetState();
}


class _NotificationsBottomSheetState extends State<NotificationsBottomSheet> {
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ParentCubit>().getNotifications();
  }

  void _updateActiveTabIndex(int index) {
    setState(() {
      _activeTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentCubit, ParentState>(
      builder: (context, state) {
        if (state.status == ParentStatus.loading && state.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final notifications = state.notifications;

        return DefaultTabController(
          length: 3,
          initialIndex: _activeTabIndex,
          child: Column(
            children: [
              const Text(
                'الاشعارات',
                style: TextStyle(
                  fontSize: 21.44,
                  fontWeight: FontWeight.w700,
                  color: AppColors.c721D1D,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    TabBar(
                      labelPadding: const EdgeInsets.all(8),
                      onTap: (index) {
                        _updateActiveTabIndex(index);
                      },
                      tabs: [
                        _buildTab('الكل', 0),
                        _buildTab('غير مقروءه', 1),
                        _buildTab('مقروءه', 2),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildNotificationList(notifications),
                          _buildNotificationList(notifications.where((n) => !n.isRead).toList()),
                          _buildNotificationList(notifications.where((n) => n.isRead).toList()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab(String title, int index) {
    return Text(
      title,
      style: _activeTabIndex == index
          ? TextStyle(
              fontSize: 14.29,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(0, 4.03),
                  blurRadius: 4.03,
                ),
              ],
            )
          : const TextStyle(
              fontSize: 14.29,
              color: AppColors.c721D1D,
              fontWeight: FontWeight.w400,
            ),
    );
  }

  Widget _buildNotificationList(List<dynamic> notifications) {
    if (notifications.isEmpty) {
      return const Center(child: Text('لا توجد اشعارات'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            spacing: 10,
            children: [
              Container(
                width: 42.94,
                height: 42.94,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
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
                      style: const TextStyle(
                        fontSize: 12.27,
                        fontWeight: FontWeight.w600,
                        color: AppColors.c721D1D,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        notification.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9.82,
                          fontWeight: FontWeight.w400,
                          color: AppColors.c721D1D,
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
