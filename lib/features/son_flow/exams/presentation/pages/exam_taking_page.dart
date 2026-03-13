import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_image.dart';
import 'package:lms/features/son_flow/exams/data/models/exam_model.dart';
import 'package:lms/features/son_flow/exams/data/models/question_model.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_cubit.dart';
import 'package:lms/features/son_flow/exams/presentation/manager/exam_state.dart';
import 'package:lms/core/routing/app_routes.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ExamTakingPage extends StatefulWidget {
  final String examId;

  const ExamTakingPage({super.key, required this.examId});

  @override
  State<ExamTakingPage> createState() => _ExamTakingPageState();
}

class _ExamTakingPageState extends State<ExamTakingPage> {
  final Map<String, String> _answers = {};
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    context.read<ExamCubit>().loadExam(widget.examId);
  }

  void _startTimer(int durationMinutes) {
    _remainingSeconds = durationMinutes * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _submitExam();
      }
    });
  }

  void _submitExam() {
    if (_isSubmitting) return;
    
    setState(() {
      _isSubmitting = true;
    });
    
    _timer?.cancel();
    context.read<ExamCubit>().submitExam(widget.examId, _answers);
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isSubmitting) return false;
        
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('تحذير'),
            content: const Text('هل أنت متأكد من الخروج؟ سيتم فقدان إجاباتك.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('خروج', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('الامتحان'),
          centerTitle: true,
          actions: [
            if (_remainingSeconds > 0)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _remainingSeconds < 300 ? Colors.red.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer,
                        size: 18,
                        color: _remainingSeconds < 300 ? Colors.red : AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _remainingSeconds < 300 ? Colors.red : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        body: BlocConsumer<ExamCubit, ExamState>(
          listener: (context, state) {
            if (state is ExamLoaded && _timer == null) {
              final durationMinutes = state.exam.durationMinutes ?? 30;
              _startTimer(durationMinutes);
            } else if (state is ExamSubmitted) {
              _timer?.cancel();
              context.pushReplacementNamed(
                AppRoutes.examResults, 
                extra: {
                  'attemptId': state.submission.attemptId.toString(),
                  'examId': widget.examId,
                }
              );
            } else if (state is ExamError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              setState(() {
                _isSubmitting = false;
              });
            }
          },
          builder: (context, state) {
            if (state is ExamLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExamLoaded) {
              final exam = state.exam;
              final questions = exam.questions ?? [];

              if (questions.isEmpty) {
                return const Center(child: Text('لا توجد أسئلة في هذا الامتحان'));
              }

              return Column(
                children: [
                  // Progress indicator
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: AppColors.cF6F7FA,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            exam.title,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '${_answers.length} / ${questions.length}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  // Questions list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        return _buildQuestionCard(question, index + 1);
                      },
                    ),
                  ),
                  // Submit button
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitExam,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'إرسال الإجابات',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                ],
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
                      onPressed: () => context.read<ExamCubit>().loadExam(widget.examId),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildQuestionCard(QuestionModel question, int questionNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$questionNumber',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (question.difficulty != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(question.difficulty!).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    question.difficulty!,
                    style: TextStyle(
                      fontSize: 11,
                      color: _getDifficultyColor(question.difficulty!),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Question text
          // Question text (HTML)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: HtmlWidget(
              question.questionText,
              textStyle: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
            ),
          ),
          // Question image
         // ابحث عن السطر ده وغيره:
if (question.questionImage != null && question.questionImage!.isNotEmpty) ...[
  const SizedBox(height: 12),
  ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Container(
      color: Colors.black12, // خلفية خفيفة عشان لو الصورة بيضاء تبان
      child: InteractiveViewer( // الطالب يقدر يزوم بصوابعه
        clipBehavior: Clip.none,
        child: CustomImage(
          imagePath: question.questionImage,
          width: double.infinity,
          // height: 200, // امسح الارتفاع الثابت أو خليه maxHeight
          fit: BoxFit.contain, // ✅ الحل هنا: contain بيعرض الصورة كاملة
        ),
      ),
    ),
  ),
],
          const SizedBox(height: 16),
          // Options
          if (question.isMultipleChoice)
            ...question.optionsList.asMap().entries.map((entry) {
              final index = entry.key;
              final dynamic rawOption = entry.value;
              String optionValueString = '';
              Widget optionContent;

              // Parse option to determine value and display widget
              if (rawOption is Map) {
                if (rawOption.containsKey('text')) {
                  optionValueString = rawOption['text']?.toString() ?? '';
                  optionContent = Text(
                    optionValueString,
                    style: const TextStyle(fontSize: 15),
                  );
                } // ابحث عن الجزء ده في الـ Options list وغيره:
else if (rawOption.containsKey('image')) {
  optionValueString = rawOption['image']?.toString() ?? '';
  optionContent = ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: CustomImage(
      imagePath: optionValueString,
      height: 150, // كبر الارتفاع شوية للاختيارات
      width: double.infinity,
      fit: BoxFit.contain, // ✅ غيرها من cover لـ contain
    ),
  );
}else {
                  optionValueString = rawOption.toString();
                  optionContent = Text(optionValueString);
                }
              } else {
                optionValueString = rawOption.toString();
                // Check if string contains HTML
                if (optionValueString.contains('<') && optionValueString.contains('>')) {
                   optionContent = HtmlWidget(optionValueString);
                } else {
                   optionContent = Text(
                    optionValueString,
                    style: const TextStyle(fontSize: 15),
                   );
                }
              }

              final isSelected = _answers[question.id] == optionValueString;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _answers[question.id] = optionValueString;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.cF6F7FA,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.primary : Colors.white,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: optionContent,
                      ),
                    ],
                  ),
                ),
              );
            }).toList()
          else
            TextField(
              decoration: InputDecoration(
                hintText: 'اكتب إجابتك هنا...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: AppColors.cF6F7FA,
              ),
              maxLines: 3,
              onChanged: (value) {
                _answers[question.id] = value;
              },
            ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
      case 'سهل':
        return Colors.green;
      case 'medium':
      case 'متوسط':
        return Colors.orange;
      case 'hard':
      case 'صعب':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
