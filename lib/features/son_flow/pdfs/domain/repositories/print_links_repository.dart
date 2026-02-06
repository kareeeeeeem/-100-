import 'package:lms/core/models/result.dart';
import 'package:lms/features/son_flow/pdfs/data/models/print_links_model.dart';

abstract class PrintLinksRepository {
  Future<Result<PrintLinksData>> getPrintLinks(String sectionId);
}
