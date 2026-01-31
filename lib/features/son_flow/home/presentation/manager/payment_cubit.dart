import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';

abstract class PaymentState {}
class PaymentInitial extends PaymentState {}
class PaymentLoading extends PaymentState {}
class PaymentSuccess extends PaymentState {}
class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}

class PaymentCubit extends Cubit<PaymentState> {
  final HomeRepository repository;
  PaymentCubit(this.repository) : super(PaymentInitial());

  Future<void> checkout({
    required int courseId,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String paymentType,
  }) async {
    emit(PaymentLoading());
    final result = await repository.checkout(
      courseId: courseId,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
      paymentType: paymentType,
    );
    if (result.isSuccess) {
      emit(PaymentSuccess());
    } else {
      emit(PaymentError(result.failure?.message ?? 'Failed to complete payment'));
    }
  }
}
