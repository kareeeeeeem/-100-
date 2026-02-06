
import 'package:lms/features/son_flow/pdfs/data/models/print_links_model.dart';

abstract class PrintLinksState {}

class PrintLinksInitial extends PrintLinksState {}

class PrintLinksLoading extends PrintLinksState {}

class PrintLinksLoaded extends PrintLinksState {
  final PrintLinksData data;

  PrintLinksLoaded(this.data);
}

class PrintLinksError extends PrintLinksState {
  final String message;

  PrintLinksError(this.message);
}
