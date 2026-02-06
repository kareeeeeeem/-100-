import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/son_flow/pdfs/domain/repositories/print_links_repository.dart';
import 'package:lms/features/son_flow/pdfs/presentation/manager/print_links_state.dart';

class PrintLinksCubit extends Cubit<PrintLinksState> {
  final PrintLinksRepository _repository;

  PrintLinksCubit(this._repository) : super(PrintLinksInitial());

  Future<void> getPrintLinks(String sectionId) async {
    emit(PrintLinksLoading());
    final result = await _repository.getPrintLinks(sectionId);
    if (result.isSuccess) {
      emit(PrintLinksLoaded(result.data!));
    } else {
      emit(PrintLinksError(result.failure?.message ?? 'Unknown error'));
    }
  }
}
