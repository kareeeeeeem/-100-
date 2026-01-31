import 'package:flutter/material.dart';
import 'package:lms/features/son_flow/home/data/model/profile_response_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_svgs.dart';
import 'package:lms/core/widgets/custom_container.dart';
import 'package:lms/features/son_flow/home/presentation/manager/profile_cubit.dart';
import 'package:lms/features/son_flow/home/presentation/manager/profile_state.dart';
import 'package:lms/features/son_flow/course/presentation/widgets/running_course_item_view.dart';
import 'package:lms/features/son_flow/profile/presentation/widgets/profile_chart.dart';
import 'package:lms/core/widgets/profile_image_and_edit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // بنادي الداتا أول ما الصفحة تفتح
    context.read<ProfileCubit>().getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileSuccess) {
          // هنا الداتا بقت جاهزة
          final data = state.profileModel.data;

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. صورة البروفايل
                    ProfileImageAndEdit(
  imageSize: 150,
  // نقوم بتمرير رابط صورة التلميذ من البيانات القادمة
  // إذا كان data.image فارغاً، يمكنك وضع رابط لصورة افتراضية (placeholder)
  imagePath: data?.image ?? 'assets/images/default_student.png', 
  onEditTap: () => context.pushNamed(AppRoutes.sonProfileDetails),
),
                    const SizedBox(height: 10),
                    
                    // 2. الاسم (اللي هينطق eeee)
                    Text(
                      data?.name ?? 'اسم المستخدم', 
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    
                    // 3. كارت التقدم
                    _buildProgressCard(data?.overallProgress ?? 0),
                    
                    const SizedBox(height: 10),
                    
                    // 4. الصناديق الثلاثة
                    Row(
                      spacing: 10,
                      children: [
                        _buildStatBox(AppSvgs.book, '${data?.enrolledCoursesCount ?? 0}', 'تم التسجيل'),
                        _buildStatBox(AppSvgs.check, '${data?.completedCoursesCount ?? 0}', 'مكتمل'),
                        _buildStatBox(AppSvgs.coin, '${data?.certificatesCount ?? 0}', 'شهادات'),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    _buildLiveButton(context),
                    const SizedBox(height: 20),
                    _buildCoursesHeader(),
                    const SizedBox(height: 10),
                    _buildCoursesList(data?.recentCourses),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    _buildActivitySummary(data),
                    const SizedBox(height: 30),
                    
                    // 5. أزرار تسجيل الخروج وحذف الحساب
                    BlocConsumer<ProfileCubit, ProfileState>(
                      listener: (context, state) {
  if (state is LogoutSuccess || state is DeleteAccountSuccess) {
    // استخدم go عشان تقفل كل الصفحات القديمة وتفتح اللوجين كأنك فاتح التطبيق لأول مرة
    context.go(AppRoutes.login); 
  } else if (state is LogoutError) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
  }else if (state is DeleteAccountError) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            _buildActionTile(
                              icon: Icons.logout,
                              label: 'تسجيل الخروج',
                              color: Colors.orange,
                              isLoading: state is LogoutLoading,
                              onTap: () => _showConfirmDialog(
                                context,
                                title: 'تسجيل الخروج',
                                message: 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
                                onConfirm: () => context.read<ProfileCubit>().logout(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildActionTile(
                              icon: Icons.delete_forever,
                              label: 'حذف الحساب',
                              color: Colors.red,
                              isLoading: state is DeleteAccountLoading,
                              onTap: () => _showConfirmDialog(
                                context,
                                title: 'حذف الحساب',
                                message: 'هذا الإجراء نهائي ولا يمكن التراجع عنه. هل أنت متأكد؟',
                                onConfirm: () => context.read<ProfileCubit>().deleteAccount(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        } else if (state is ProfileError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }

  // --- الميثودز المساعدة ---

  Widget _buildProgressCard(num progress) {
    return Card(
      color: AppColors.cF6F7FA,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('التقدم العام', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text('${(progress.toDouble() * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ],
            ),
            LinearProgressIndicator(
              minHeight: 14,
              borderRadius: BorderRadius.circular(10),
              value: progress.toDouble(),
              backgroundColor: AppColors.cD9D9D9,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(dynamic icon, String value, String label) {
    return Expanded(
      child: CustomContainer(
        height: 110,
        borderAlpha: 0.4,
        borderWidth: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            icon.svg(fit: BoxFit.scaleDown),
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveButton(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(AppRoutes.availableLives),
      child: CustomContainer(
        borderRadius: 10,
        borderAlpha: 0.4,
        borderWidth: 0.3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 10,
            children: [
              Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10))),
              const Text('شاهد البثوث المتاحه', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoursesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('الدورات الخاصة بي', style: TextStyle(fontSize: 18.66, fontWeight: FontWeight.w700, color: AppColors.c303030)),
       // InkWell(onTap: () {}, child: const Text('عرض المزيد', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
      ],
    );
  }
// خليها تستقبل Parameter من نوع List
Widget _buildCoursesList(List<dynamic>? courses) { 
  if (courses == null || courses.isEmpty) {
    return const Center(child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Text("لا توجد دورات حالياً"),
    ));
  }

  return CustomContainer(
    borderAlpha: 0.5,
    borderWidth: 0.4,
    child: ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: courses.length > 2 ? 2 : courses.length, // يعرض أول كورسين بس في البروفايل
      separatorBuilder: (context, index) => Divider(color: AppColors.c737373.withOpacity(0.5)),
      itemBuilder: (context, index) {
        final course = courses[index];
        return RunningCourseItemView(
          courseName: course.title ?? 'بدون عنوان',
          // حولنا الـ String لـ double وقسمنا على 100
          progress: (double.tryParse(course.progressPercentage?.toString() ?? '0') ?? 0.0) / 100,
          imageUrl: course.thumbnail,
        );
      },
    ),
  );
}

  Widget _buildActivitySummary(ProfileData? data) {
    return Column(
      children: [
        const Align(alignment: AlignmentDirectional.centerStart, child: Text('ملخص نشاط الطالب', style: TextStyle(fontSize: 18.66, fontWeight: FontWeight.w700))),
        const SizedBox(height: 10),
        CustomContainer(
          borderAlpha: 0.5,
          borderWidth: 0.3,
          height: 200,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${data?.dashboardStats?.studyHoursWeek.fold<int>(0, (p, c) => p + (c as int)) ?? 0} ساعة'),
                    const Divider(),
                    Text('${data?.dashboardStats?.completedTasks ?? 0} درس'),
                  ],
                ),
              ),
              Expanded(flex: 3, child: ProfileChart(data: data?.dashboardStats?.studyHoursWeek)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required Color color,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: CustomContainer(
        borderRadius: 10,
        borderAlpha: 0.4,
        borderWidth: 0.3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 15),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const Spacer(),
              if (isLoading)
                const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              else
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, {required String title, required String message, required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('تأكيد', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}