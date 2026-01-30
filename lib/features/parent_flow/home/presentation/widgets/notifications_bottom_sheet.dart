import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_colors.dart';

class NotificationsBottomSheet extends StatefulWidget {
  const NotificationsBottomSheet({super.key});

  @override
  State<NotificationsBottomSheet> createState() =>
      _NotificationsBottomSheetState();
}

class _NotificationsBottomSheetState extends State<NotificationsBottomSheet> {
  int _activeTabIndex = 0;

  void _updateActiveTabIndex(int index) {
    setState(() {
      _activeTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    Text(
                      'الكل',
                      style: _activeTabIndex == 0
                          ? TextStyle(
                              fontSize: 14.29,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
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
                    ),
                    Text(
                      'غير مقروءه',
                      style: _activeTabIndex == 1
                          ? TextStyle(
                              fontSize: 14.29,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
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
                    ),
                    Text(
                      'مقروءه',
                      style: _activeTabIndex == 2
                          ? TextStyle(
                              fontSize: 14.29,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
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
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
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
                                const Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 6,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'الدكتور محمد الصعيدي',
                                        style: TextStyle(
                                          fontSize: 12.27,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.c721D1D,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          'قام ابنك ب حضور الدورة متاخرا 15 دقيقة',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
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
                            color: AppColors.c737373.withValues(alpha: 0.7),
                          );
                        },
                        itemCount: 20,
                      ),
                      ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
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
                                const Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 6,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'الدكتور محمد الصعيدي',
                                        style: TextStyle(
                                          fontSize: 12.27,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.c721D1D,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          'قام ابنك ب حضور الدورة متاخرا 15 دقيقة',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
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
                            color: AppColors.c737373.withValues(alpha: 0.7),
                          );
                        },
                        itemCount: 20,
                      ),
                      ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
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
                                const Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 6,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'الدكتور محمد الصعيدي',
                                        style: TextStyle(
                                          fontSize: 12.27,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.c721D1D,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          'قام ابنك ب حضور الدورة متاخرا 15 دقيقة',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
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
                            color: AppColors.c737373.withValues(alpha: 0.7),
                          );
                        },
                        itemCount: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
