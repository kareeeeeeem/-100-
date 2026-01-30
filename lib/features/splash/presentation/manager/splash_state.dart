part of 'splash_cubit.dart';

@immutable
final class SplashState extends Equatable {
  final bool isOnBoardingCompleted;
  final bool isUserLoggedIn;
  final String? userType;
  final String? userName; // موجودة تمام

  const SplashState({
    this.isOnBoardingCompleted = false,
    this.isUserLoggedIn = false,
    this.userType,
    this.userName,
  });

// داخل SplashState
SplashState copyWith({
  bool? isOnBoardingCompleted,
  bool? isUserLoggedIn,
  String? userType,
  String? userName, // موجودة
}) {
  return SplashState(
    isOnBoardingCompleted: isOnBoardingCompleted ?? this.isOnBoardingCompleted,
    isUserLoggedIn: isUserLoggedIn ?? this.isUserLoggedIn,
    userType: userType ?? this.userType,
    userName: userName ?? this.userName, // لازم تتحدث هنا
  );
}

@override
List<Object?> get props => [isOnBoardingCompleted, isUserLoggedIn, userType, userName];}