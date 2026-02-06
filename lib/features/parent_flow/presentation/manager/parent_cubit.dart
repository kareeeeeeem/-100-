import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/service/cache_service.dart';
import 'package:lms/features/parent_flow/data/models/parent_payment_model.dart';
import 'package:lms/features/parent_flow/domain/repositories/parent_repository.dart';
import 'package:lms/features/parent_flow/presentation/manager/parent_state.dart';

class ParentCubit extends Cubit<ParentState> {
  final ParentRepository _repository;
  final CacheService _cacheService;
  final Set<int> _hiddenChildIds = {};
  static const String _hiddenChildrenKey = 'hidden_children_ids';

  bool _isCacheLoaded = false;

  ParentCubit(this._repository, this._cacheService) : super(const ParentState()) {
    _loadCache();
  }

  Future<void> _loadCache() async {
    await _loadHiddenChildIds();
    _isCacheLoaded = true;
  }

  Future<void> _loadHiddenChildIds() async {
    try {
      final List<String>? hidden = await _cacheService.get<List<String>>(_hiddenChildrenKey);
      if (hidden != null) {
        _hiddenChildIds.addAll(hidden.map((id) => int.tryParse(id) ?? 0).where((id) => id != 0));
        print("📦 [ParentCubit] Loaded hidden children: $_hiddenChildIds");
      }
    } catch (e) {
      print("⚠️ [ParentCubit] Error loading hidden children: $e");
    }
  }

  Future<void> _saveHiddenChildIds() async {
    try {
      await _cacheService.set(_hiddenChildrenKey, _hiddenChildIds.map((id) => id.toString()).toList());
    } catch (e) {
      print("⚠️ [ParentCubit] Error saving hidden children: $e");
    }
  }

  Future<void> getProfile({bool isSilent = false}) async {
    if (!isSilent) emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.getProfile();
    
    if (result.isSuccess) {
      emit(state.copyWith(status: ParentStatus.success, profile: result.data));
    } else {
      if (!isSilent) {
        emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
      } else {
        print("🤫 [ParentCubit] Silent getProfile failed: ${result.failure?.message}");
      }
    }
  }

  Future<void> getChildren({bool isSilent = false}) async {
    if (!_isCacheLoaded) {
      await _loadHiddenChildIds();
      _isCacheLoaded = true;
    }
    if (!isSilent) emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.getChildren();
    
    if (result.isSuccess) {
      // تصفية الأبناء المخفيين محلياً
      final visibleChildren = result.data?.where((child) => !_hiddenChildIds.contains(child.id)).toList() ?? [];
      emit(state.copyWith(status: ParentStatus.success, children: visibleChildren));
    } else {
      if (!isSilent) {
        emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
      } else {
        print("🤫 [ParentCubit] Silent getChildren failed: ${result.failure?.message}");
      }
    }
  }

  Future<void> addChild(Map<String, dynamic> data) async {
    emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.addChild(data);
    
    if (result.isSuccess) {
      emit(state.copyWith(status: ParentStatus.childAdded));
      getChildren(isSilent: true); // Refresh list silently
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
      getPayments(); // Refresh requests list
      getParentCourses(); // Refresh courses list to show newly unlocked course
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
      getChildren(isSilent: true); // Refresh list silently
    } else {
      emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
    }
  }

  Future<void> deleteChild(int childId) async {
    emit(state.copyWith(status: ParentStatus.loading));
    
    // بما أن الباك إند حالياً لا يدعم الحذف المباشر (Method Not Allowed)
    // سنقوم بتنفيذ "الحذف المحلي" أو الإخفاء لضمان تجربة مستخدم جيدة
    
    try {
      // محاولة الحذف من السيرفر (اختياري، في حال تم تفعيلها لاحقاً)
      await _repository.deleteChild(childId);
    } catch (e) {
      print("ℹ️ Backend delete failed as expected, proceeding with local hide: $e");
    }

    // الإخفاء محلياً
    _hiddenChildIds.add(childId);
    await _saveHiddenChildIds();

    emit(state.copyWith(status: ParentStatus.childDeleted));
    
    // تحديث القائمة فوراً
    final updatedChildren = state.children.where((child) => child.id != childId).toList();
    emit(state.copyWith(status: ParentStatus.success, children: updatedChildren));
  }

  Future<void> getParentCourses({bool isSilent = false}) async {
    if (!_isCacheLoaded) {
      await _loadHiddenChildIds();
      _isCacheLoaded = true;
    }
    if (!isSilent) emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.getParentCourses();
    
    if (result.isSuccess) {
      emit(state.copyWith(status: ParentStatus.success, courses: result.data));
    } else {
      if (!isSilent) {
        emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
      } else {
        print("🤫 [ParentCubit] Silent getParentCourses failed: ${result.failure?.message}");
      }
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

  Future<void> getLiveSessions({bool isSilent = false}) async {
    if (!isSilent) emit(state.copyWith(status: ParentStatus.loading));
    final result = await _repository.getLiveSessions();

    if (result.isSuccess) {
      final data = result.data;
      final rawList = data?['available_now'];
      final List<dynamic> availableNow = (rawList is List) ? rawList : [];
      
      emit(state.copyWith(status: ParentStatus.success, liveSessions: availableNow));
    } else {
      if (!isSilent) {
        emit(state.copyWith(status: ParentStatus.error, errorMessage: result.failure?.message));
      } else {
        print("🤫 [ParentCubit] Silent getLiveSessions failed: ${result.failure?.message}");
      }
    }
  }
}
