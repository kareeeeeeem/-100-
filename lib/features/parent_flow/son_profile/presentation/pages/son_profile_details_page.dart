import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/core/widgets/profile_image_and_edit.dart';
import 'package:lms/core/widgets/profile_text_form_field.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_cubit.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_state.dart';
import 'package:lms/features/parent_flow/course/presentation/widgets/running_course_item_view.dart';

class SonProfileDetailsPage extends StatefulWidget {
  final int childId;

  const SonProfileDetailsPage({super.key, required this.childId});

  @override
  State<SonProfileDetailsPage> createState() => _SonProfileDetailsPageState();
}

class _SonProfileDetailsPageState extends State<SonProfileDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch details when page initializes
    context.read<ParentCubit>().getChildDetails(widget.childId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بيانات الابن')),
      body: BlocConsumer<ParentCubit, ParentState>(
        listener: (context, state) {
          if (state.status == ParentStatus.childDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم حذف الابن بنجاح')),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          if (state.status == ParentStatus.loading) {
             return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ParentStatus.error) {
             return Center(child: Text(state.errorMessage ?? 'حدث خطأ غير متوقع'));
          }

          final child = state.selectedChild;
          if (child != null) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   ProfileImageAndEdit(
                    imageSize: 121.5,
                    showEditIcon: false,
                    imagePath: child.avatar,
                  ),
                  const SizedBox(height: 30),
                  ProfileTextFormField(
                    hintText: child.name,
                    readOnly: true,
                    prefix: const Icon(Icons.person, color: AppColors.cADB3BC),
                  ),
                  const SizedBox(height: 20),
                  ProfileTextFormField(
                    hintText: child.email ?? 'لا يوجد بريد إلكتروني',
                    readOnly: true,
                    prefix: const Icon(Icons.email, color: AppColors.cADB3BC),
                  ),
                  const SizedBox(height: 20),
                  const ProfileTextFormField(
                    hintText: '*****************',
                    readOnly: true,
                    prefix: Icon(Icons.visibility_off, color: AppColors.cADB3BC),
                  ),
                  const SizedBox(height: 30),
                  // إحصائيات الطالب
                  if (child.stats != null) ...[
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            title: 'ساعات التعلم',
                            value: '${child.stats!['hours'] ?? 0}',
                            icon: Icons.access_time,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildStatItem(
                            title: 'الدروس المنجزة',
                            value: '${child.stats!['lessons'] ?? 0}',
                            icon: Icons.menu_book,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                  // الدورات
                  if (child.courses != null && child.courses!.isNotEmpty) ...[
                     const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'الدورات الملتحق بها',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: child.courses!.length,
                      itemBuilder: (context, index) {
                        return RunningCourseItemView(courseItem: child.courses![index]);
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                    ),
                    const SizedBox(height: 30),
                  ],
                   if (child.courses == null || child.courses!.isEmpty)
                     const Padding(
                       padding: EdgeInsets.symmetric(vertical: 20),
                       child: Center(child: Text('لا توجد دورات مسجلة')),
                     ),

                  CustomElevatedButton(
                    title: 'تعديل',
                    onPressed: () async {
                      await context.pushNamed(
                        AppRoutes.editProfileDetailsParent,
                        extra: child.id,
                      );
                      if (context.mounted) {
                        context.read<ParentCubit>().getChildDetails(child.id);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomElevatedButton(
                    title: 'حذف الابن',
                    buttonStyle: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.39)),
                    ),
                    onPressed: () => _showDeleteConfirmation(context, child.id),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          return const Center(child: Text('لا توجد بيانات'));
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int childId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف الابن'),
        content: const Text('هل أنت متأكد من رغبتك في حذف هذا الابن؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ParentCubit>().deleteChild(childId);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({required String title, required String value, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
