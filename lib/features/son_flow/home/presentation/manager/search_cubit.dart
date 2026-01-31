import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/home/data/model/home_response_model.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';

abstract class SearchState {}
class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchSuccess extends SearchState {
  final List<CourseModel> courses;
  SearchSuccess(this.courses);
}
class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

class SearchCubit extends Cubit<SearchState> {
  final HomeRepository repository;
  SearchCubit(this.repository) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    final result = await repository.searchCourses(query);
    if (result.isSuccess) {
      emit(SearchSuccess(result.data ?? []));
    } else {
      emit(SearchError(result.failure?.message ?? 'Failed to search courses'));
    }
  }
}
