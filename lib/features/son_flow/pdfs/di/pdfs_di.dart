import 'package:get_it/get_it.dart';
import 'package:lms/features/son_flow/pdfs/data/data_sources/print_links_api_service.dart';
import 'package:lms/features/son_flow/pdfs/data/repositories/print_links_repository_impl.dart';
import 'package:lms/features/son_flow/pdfs/domain/repositories/print_links_repository.dart';
import 'package:lms/features/son_flow/pdfs/presentation/manager/print_links_cubit.dart';

import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';

class PDFsDi {
  static Future<void> init() async {
    final sl = GetIt.instance;

    // Data Sources
    sl.registerLazySingleton<PrintLinksApiService>(
        () => PrintLinksApiService(sl<ApiService>(), sl<JwtService>()));

    // Repositories
    sl.registerLazySingleton<PrintLinksRepository>(
        () => PrintLinksRepositoryImpl(sl()));

    // Cubits
    sl.registerFactory(() => PrintLinksCubit(sl()));
  }
}
