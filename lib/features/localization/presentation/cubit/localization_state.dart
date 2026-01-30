part of 'localization_cubit.dart';

class LocalizationState extends Equatable {
  const LocalizationState({this.currentLocale = AppLocale.english});

  final AppLocale currentLocale;

  LocalizationState copyWith({AppLocale? locale}) {
    return LocalizationState(currentLocale: locale ?? currentLocale);
  }

  @override
  List<Object?> get props => [currentLocale];
}
