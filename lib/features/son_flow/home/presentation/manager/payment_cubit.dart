import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';

abstract class PaymentState {}
class PaymentInitial extends PaymentState {}
class PaymentLoading extends PaymentState {}
class PaymentSuccess extends PaymentState {}
class PaymentRedirect extends PaymentState {
  final String url;
  PaymentRedirect(this.url);
}
class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}

class PaymentCubit extends Cubit<PaymentState> {
  final HomeRepository repository;
  PaymentCubit(this.repository) : super(PaymentInitial());

  Future<void> checkout({
    required int courseId,
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String paymentType,
  }) async {
    emit(PaymentLoading());
    final result = await repository.checkout(
      courseId: courseId,
      amount: amount,
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

  Future<void> processPayment({
    required int courseId,
    required String paymentMethod,
    String? guardianPhone,
  }) async {
    emit(PaymentLoading());
    final result = await repository.processPayment(
      courseId: courseId,
      paymentMethod: paymentMethod,
      guardianPhone: guardianPhone,
    );
    
    if (result.isSuccess) {
      final data = result.data;
      if (data?['redirect_url'] != null) {
        emit(PaymentRedirect(data!['redirect_url'].toString()));
      } else if (data?['success'] == true || data?['status'] == 'guardian_success' || data?['status'] == true) {
        emit(PaymentSuccess());
      } else {
        emit(PaymentError(data?['message']?.toString() ?? 'حدث خطأ غير متوقع في نظام الدفع'));
      }
    } else {
      emit(PaymentError(result.failure?.message ?? 'Failed to process payment'));
    }
  }
}
