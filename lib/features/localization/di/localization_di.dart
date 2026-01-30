import 'package:lms/core/constants/app_locale.dart';
import 'package:lms/core/di/app_di.dart';
import 'package:lms/core/service/cache_service.dart';
import 'package:lms/features/localization/data/data_source/local/localization_local_service.dart';
import 'package:lms/features/localization/data/data_source/local/localization_local_service_impl.dart';
import 'package:lms/features/localization/data/repository/localization_repository_impl.dart';
import 'package:lms/features/localization/domain/repository/localization_repository.dart';
import 'package:lms/features/localization/presentation/cubit/localization_cubit.dart';
import 'package:lms/features/localization/presentation/locale_provider.dart';
import 'package:lms/features/localization/presentation/locale_provider_impl.dart';

class LocaleDi extends AppDi {
  @override
  Future<void> init() async {
    sl.registerLazySingleton<LocalizationCacheService>(
      () => LocalizationCacheServiceImpl(
        sl<CacheService>(instanceName: 'SharedPrefsCacheService'),
      ),
    );

    sl.registerLazySingleton<LocalizationRepository>(
      () => LocalizationRepositoryImpl(sl<LocalizationCacheService>()),
    );

    sl.registerLazySingleton<LocalizationCubit>(
      () => LocalizationCubit(sl<LocalizationRepository>()),
    );

    final Stream<AppLocale> localeStream = sl<LocalizationCubit>().stream.map(
      (state) => state.currentLocale,
    );

    sl.registerLazySingleton<LocaleProvider>(
      () => LocalProviderImpl(
        localeStream,
        sl<LocalizationCubit>().state.currentLocale,
      ),
    );
  }
}
