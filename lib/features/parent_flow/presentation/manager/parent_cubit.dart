import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/parent_flow/data/models/parent_payment_model.dart';
import 'package:lms/features/parent_flow/domain/repositories/parent_repository.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_state.dart';

class ParentCubit extends Cubit<ParentState> {
  final ParentRepository _repository;

  ParentCubit(this._repository) : super(const ParentState());

  Future<void> getProfile() async {
    emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.getProfile();
    
    if (result.isSuccess) {
      emit(state.copyWith(status: ParentStatus.success, profile: result.data));
    } else {
      emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
    }
  }

  Future<void> getChildren() async {
    emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.getChildren();
    
    if (result.isSuccess) {
      emit(state.copyWith(status: ParentStatus.success, children: result.data));
    } else {
      emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
    }
  }

  Future<void> addChild(Map<String, dynamic> data) async {
    emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.addChild(data);
    
    if (result.isSuccess) {
      emit(state.copyWith(status: ParentStatus.childAdded));
      getChildren(); // Refresh list
    } else {
      emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
    }
  }

  Future<void> getPayments() async {
    emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.getPayments();
    
    if (result.isSuccess) {
      emit(state.copyWith(status: ParentStatus.success, payments: result.data));
    } else {
      emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
    }
  }

  Future<void> checkout({
    required int courseId,
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String paymentType,
  }) async {
    emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.checkout(
      courseId: courseId,
      amount: amount,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
      paymentType: paymentType,
    );
    
    if (result.isSuccess) {
      emit(state.copyWith(status: ParentStatus.paymentSuccess));
    } else {
      emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
    }
  }

  Future<void> getChildDetails(int childId) async {
    emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.getChildDetails(childId);
    
    if (result.isSuccess) {
      emit(state.copyWith(status: ParentStatus.success, selectedChild: result.data));
    } else {
      emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
    }
  }

  Future<void> updateChild(int childId, Map<String, dynamic> data) async {
    emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.updateChild(childId, data);
    
    if (result.isSuccess) {
      emit(state.copyWith(status: ParentStatus.childUpdated));
      getChildren(); // Refresh list
    } else {
      emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
    }
  }

  Future<void> getParentCourses() async {
    emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.getParentCourses();
    
    if (result.isSuccess) {
      emit(state.copyWith(status: ParentStatus.success, courses: result.data));
    } else {
      emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
    }
  }

  Future<void> getChildExamResults(int childId) async {
    emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.getChildExamResults(childId);
    
    if (result.isSuccess) {
      emit(state.copyWith(status: ParentStatus.success, examResults: result.data));
    } else {
      emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
    }
  }
  Future<void> getNotifications() async {
    emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.getNotifications();
    
    if (result.isSuccess) {
      emit(state.copyWith(status: ParentStatus.success, notifications: result.data));
    } else {
      emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(state.copyWith(status: ParentStatus.initial)); // or any other status indicating logout
  }

  Future<void> getLiveSessions() async {
    emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.getLiveSessions();

    if (result.isSuccess) {
      final data = result.data;
      final rawList = data?['available_now'];
      final List<dynamic> availableNow = (rawList is List) ? rawList : [];
      
      emit(state.copyWith(status: ParentStatus.success, liveSessions: availableNow));
    } else {
      emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
    }
  }
}
