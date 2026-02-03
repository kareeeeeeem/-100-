import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/core/widgets/custom_container.dart';
import 'package:lms/features/parent_flow/payment/presentation/widgets/payment_bottom_sheet.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_cubit.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_state.dart';

class PaymentRequestsPage extends StatefulWidget {
  const PaymentRequestsPage({super.key});

  @override
  State<PaymentRequestsPage> createState() => _PaymentRequestsPageState();
}

class _PaymentRequestsPageState extends State<PaymentRequestsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ParentCubit>().getPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلبات الدفع')),
      body: BlocBuilder<ParentCubit, ParentState>(
        builder: (context, state) {
          if (state.status == ParentStatus.loading && state.payments.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state.status == ParentStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'حدث خطأ ما'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ParentCubit>().getPayments(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }
          
          if (state.payments.isEmpty) {
            return const Center(child: Text('لا توجد طلبات دفع'));
          }
          
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.payments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final payment = state.payments[index];
              return InkWell(
                onTap: () {
                  if (payment.courseId == null) return;
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    builder: (modalContext) {
                      return BlocProvider.value(
                        value: context.read<ParentCubit>(),
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.9,
                          child: PaymentBottomSheet(
                            courseId: payment.courseId!,
                            amount: double.tryParse(
                                    payment.amount.replaceAll(RegExp(r'[^0-9.]'), '')) ??
                                0.0,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: CustomContainer(
                  borderRadius: 5,
                  borderWidth: 0.3,
                  borderAlpha: 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AppImages.parentSectionItem.image(
                            width: 60,
                            height: 60,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                payment.courseTitle ?? 'دورة تعليمية',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              if (payment.sonName != null)
                                Text(
                                  'لـ: ${payment.sonName}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          payment.amount,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
