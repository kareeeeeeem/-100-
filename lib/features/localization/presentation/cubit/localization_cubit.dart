import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lms/core/constants/app_locale.dart';
import 'package:lms/features/localization/domain/repository/localization_repository.dart';

part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit(this._localizationRepository)
    : super(const LocalizationState());

  final LocalizationRepository _localizationRepository;

  void getInitialLocale() async {
    final AppLocale locale = await _localizationRepository.getInitialLocale();
    emit(state.copyWith(locale: locale));
  }

  void changeCurrentLocale(AppLocale locale) {
    emit(state.copyWith(locale: locale));
    _localizationRepository.saveLocale(locale);
  }
}
