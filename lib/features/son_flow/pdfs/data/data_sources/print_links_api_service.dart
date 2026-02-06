import 'package:lms/core/constants/api_constants.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/son_flow/pdfs/data/models/print_links_model.dart';

class PrintLinksApiService {
  final ApiService _apiService;
  final JwtService _jwtService;

  PrintLinksApiService(this._apiService, this._jwtService);

  Future<PrintLinksModel> getPrintLinks(String sectionId) async {
    final token = await _jwtService.getAccessToken();
    final response = await _apiService.get(
      ApiConstants.sectionPrintLinks(sectionId),
      headers: {'Authorization': 'Bearer $token'},
    );
    return PrintLinksModel.fromJson(response);
  }
}
