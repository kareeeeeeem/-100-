import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/home/data/model/home_response_model.dart';
import 'package:lms/features/son_flow/home/domain/repository/login_repository.dart';

abstract class CategoriesState {}
class CategoriesInitial extends CategoriesState {}
class CategoriesLoading extends CategoriesState {}
class CategoriesSuccess extends CategoriesState {
  final List<CategoryModel> categories;
  CategoriesSuccess(this.categories);
}
class CategoriesError extends CategoriesState {
  final String message;
  CategoriesError(this.message);
}

class CategoriesCubit extends Cubit<CategoriesState> {
  final HomeRepository repository;
  CategoriesCubit(this.repository) : super(CategoriesInitial());

  Future<void> fetchCategories() async {
    emit(CategoriesLoading());
    final result = await repository.getCategories();
    if (result.isSuccess) {
      emit(CategoriesSuccess(result.data ?? []));
    } else {
      emit(CategoriesError(result.failure?.message ?? 'Failed to load categories'));
    }
  }
}
