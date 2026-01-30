import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/features/son_flow/home/presentation/widgets/notifications_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // تأكد من إضافة هذا
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart'; // مسار الـ Repository
import 'package:lms/features/son_flow/home/presentation/manager/notifications_cubit.dart'; // مسار الـ Cubit


class SharedAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SharedAppBar({super.key});

  @override
  State<SharedAppBar> createState() => _SharedAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SharedAppBarState extends State<SharedAppBar> {
  String userName = "زائر";

  @override
  void initState() {
    super.initState();
    _loadUserData(); // بنحمل الاسم أول ما الودجت تبدأ
  }

  Future<void> _loadUserData() async {
    final jwtService = GetIt.instance<JwtService>();
    final name = await jwtService.getUserName();
    if (name != null && mounted) {
      setState(() {
        userName = name; // بنحدث الواجهة بالاسم الجديد
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 10,
      title: Row(
        children: [
          _buildUserAvatar(),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أهلاً بك $userName', 
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.c303030,
                ),
              ),
              Text(
                'استعد لتعلم مهارة جديدة اليوم',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        _buildNotificationIcon(context),
      ],
    );
  }

  // --- دوال الودجت الفرعية عشان ميبقاش فيه أخطاء (Undefined) ---

  Widget _buildUserAvatar() {
    return SizedBox(
      height: 40, width: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
          ),
          Positioned(
            bottom: 0, right: 0,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              padding: const EdgeInsets.all(2),
              child: Container(
                width: 10, height: 10,
                decoration: const BoxDecoration(color: AppColors.c4ED442, shape: BoxShape.circle),
              ),
            ),
          ),
        ],
      ),
    );
  }
Widget _buildNotificationIcon(BuildContext context) {
  return Padding(
    padding: const EdgeInsetsDirectional.only(end: 8),
    child: InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          showDragHandle: true,
          isScrollControlled: true,
          builder: (context) => BlocProvider(
            // نقوم بإنشاء الـ Cubit هنا وتمرير الـ Repository له من GetIt
            create: (context) => NotificationsCubit(GetIt.instance<HomeRepository>()),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.75, // زيادة الارتفاع قليلاً لراحة العين
              child: const NotificationsBottomSheet(),
            ),
          ),
        );
      },
      child: const Icon(Icons.notifications, color: AppColors.primary),
    ),
  );
}
}