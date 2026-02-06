import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_cubit.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_state.dart';

class ExamResultsPage extends StatefulWidget {
  final String attemptId;
  final String? examId;

  const ExamResultsPage({super.key, required this.attemptId, this.examId});

  @override
  State<ExamResultsPage> createState() => _ExamResultsPageState();
}

class _ExamResultsPageState extends State<ExamResultsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExamCubit>().loadExamResults(widget.attemptId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('نتيجة الامتحان'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
      ),
      body: BlocBuilder<ExamCubit, ExamState>(
        builder: (context, state) {
          if (state is ExamResultsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExamResultsLoaded) {
            final result = state.results;
            final isPassed = result.isPassed;
            final score = result.score;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Result icon and status
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPassed ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    ),
                    child: Icon(
                      isPassed ? Icons.check_circle : Icons.cancel,
                      size: 80,
                      color: isPassed ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Status text
                  Text(
                    result.status,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isPassed ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Score card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.cF6F7FA,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isPassed ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'درجتك',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          score,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: isPassed ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'من ${result.totalQuestions} سؤال',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Details section
                  _buildDetailRow(
                    icon: Icons.assignment_outlined,
                    label: 'رقم المحاولة',
                    value: result.id,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.quiz_outlined,
                    label: 'عدد الأسئلة',
                    value: result.totalQuestions,
                  ),
                  const SizedBox(height: 32),
                  // Motivational message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isPassed ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isPassed ? Icons.emoji_events : Icons.info_outline,
                          color: isPassed ? Colors.green : Colors.orange,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isPassed
                                ? 'أحسنت! لقد نجحت في الامتحان. استمر في التقدم!'
                                : 'لا تقلق، يمكنك المحاولة مرة أخرى. راجع المادة وحاول من جديد.',
                            style: TextStyle(
                              fontSize: 14,
                              color: isPassed ? Colors.green.shade700 : Colors.orange.shade700,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Action buttons
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => context.pop(), // Back to Section Details (or Home if deep linked)
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'العودة للدرس',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (!isPassed) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          if (widget.examId != null) {
                             context.pushReplacementNamed('examTaking', extra: widget.examId!);
                          } else {
                             context.pop(); // Fallback if no ID (shouldn't happen with new flow)
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'إعادة المحاولة',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          } else if (state is ExamError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ExamCubit>().loadExamResults(widget.attemptId),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cF6F7FA,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.c303030,
            ),
          ),
        ],
      ),
    );
  }
}
