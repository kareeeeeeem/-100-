import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:lms/features/son_flow/dashboard/presentation/manager/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repository;

  DashboardCubit(this._repository) : super(DashboardInitial());

  Future<void> loadDashboardStats() async {
    emit(DashboardLoading());
    final result = await _repository.getDashboardStats();

    if (result.isSuccess) {
      emit(DashboardStatsLoaded(result.data!));
    } else {
      emit(DashboardError(result.failure?.message ?? 'Unknown Error'));
    }
  }
}
