import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/features/son_flow/home/presentation/manager/transactions/transactions_cubit.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionsCubit>().fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cF6F7FA,
      appBar: AppBar(
        title: const Text('سجل العمليات المالية'),
      ),
      body: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          if (state is TransactionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<TransactionsCubit>().fetchTransactions(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          } else if (state is TransactionsSuccess) {
            final transactions = state.transactions;
            if (transactions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_edu_rounded, size: 80, color: Colors.grey.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    const Text('لا توجد عمليات مالية حالياً', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (transaction.type.toLowerCase() == 'income' 
                                  ? AppColors.c589B6E 
                                  : (transaction.type.toLowerCase() == 'expense' ? Colors.red : Colors.orange))
                              .withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          transaction.type.toLowerCase() == 'income' 
                              ? Icons.arrow_downward_rounded 
                              : (transaction.type.toLowerCase() == 'expense' ? Icons.arrow_upward_rounded : Icons.replay_rounded),
                          color: transaction.type.toLowerCase() == 'income' 
                              ? AppColors.c589B6E 
                              : (transaction.type.toLowerCase() == 'expense' ? Colors.red : Colors.orange),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.description,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.c303030),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              transaction.date,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            if (transaction.paymentMethod.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                'عبر: ${transaction.paymentMethod}',
                                style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${transaction.amount} EGP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: transaction.type.toLowerCase() == 'income' ? AppColors.c589B6E : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.c589B6E.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'مكتملة',
                              style: TextStyle(fontSize: 10, color: AppColors.c589B6E, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
