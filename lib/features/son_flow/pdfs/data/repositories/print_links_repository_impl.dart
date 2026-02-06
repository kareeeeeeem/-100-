import 'package:lms/core/errors/error_handler.dart';
import 'package:lms/core/errors/failures.dart';
import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/pdfs/data/data_sources/print_links_api_service.dart';
import 'package:lms/features/son_flow/pdfs/data/models/print_links_model.dart';
import 'package:lms/features/son_flow/pdfs/domain/repositories/print_links_repository.dart';

class PrintLinksRepositoryImpl implements PrintLinksRepository {
  final PrintLinksApiService _apiService;

  PrintLinksRepositoryImpl(this._apiService);

  @override
  Future<Result<PrintLinksData>> getPrintLinks(String sectionId) async {
    try {
      final response = await _apiService.getPrintLinks(sectionId);
      if (response.status == true && response.data != null) {
        return Result.success(response.data!);
      } else {
        return Result.error(ServerFailure(response.message ?? 'Unknown error'));
      }
    } catch (e) {
      return Result.error(ErrorHandler.getFailure(e));
    }
  }
}
