import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/community/domain/repository/community_repository.dart';

abstract class FavoriteState {}
class FavoriteInitial extends FavoriteState {}
class FavoriteLoading extends FavoriteState {}
class FavoriteSuccess extends FavoriteState {
  final bool isFavorited;
  FavoriteSuccess(this.isFavorited);
}
class FavoriteError extends FavoriteState {
  final String message;
  FavoriteError(this.message);
}

class FavoriteCubit extends Cubit<FavoriteState> {
  final CommunityRepository repository;
  FavoriteCubit(this.repository) : super(FavoriteInitial());

  Future<void> toggleFavorite(int courseId) async {
    emit(FavoriteLoading());
    final result = await repository.toggleFavorite(courseId);
    if (result.isSuccess) {
      emit(FavoriteSuccess(result.data ?? false));
    } else {
      emit(FavoriteError(result.failure?.message ?? 'Failed to toggle favorite'));
    }
  }
}
