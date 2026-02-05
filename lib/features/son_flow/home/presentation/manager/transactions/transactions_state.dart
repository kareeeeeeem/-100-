part of 'transactions_cubit.dart';

abstract class TransactionsState {}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsSuccess extends TransactionsState {
  final List<TransactionModel> transactions;
  TransactionsSuccess(this.transactions);
}

class TransactionsError extends TransactionsState {
  final String message;
  TransactionsError(this.message);
}
