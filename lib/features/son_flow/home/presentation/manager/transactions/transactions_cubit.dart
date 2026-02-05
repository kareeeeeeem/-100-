import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/home/data/model/transaction_response_model.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final HomeRepository _homeRepository;

  TransactionsCubit(this._homeRepository) : super(TransactionsInitial());

  Future<void> fetchTransactions() async {
    emit(TransactionsLoading());
    final result = await _homeRepository.getTransactions();
    if (result.isSuccess) {
      emit(TransactionsSuccess(result.data!.data));
    } else {
      emit(TransactionsError(result.failure?.message ?? "خطأ في جلب البيانات"));
    }
  }
}
