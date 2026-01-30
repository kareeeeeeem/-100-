part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final HomeResponseModel? homeData;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.homeData,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    HomeResponseModel? homeData,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      homeData: homeData ?? this.homeData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, homeData, errorMessage];
}