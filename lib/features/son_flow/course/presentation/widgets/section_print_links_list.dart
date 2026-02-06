
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/features/son_flow/pdfs/presentation/manager/print_links_cubit.dart';
import 'package:lms/features/son_flow/pdfs/presentation/manager/print_links_state.dart';
import 'package:url_launcher/url_launcher.dart';

class SectionPrintLinksList extends StatelessWidget {
  final String sectionId;

  const SectionPrintLinksList({super.key, required this.sectionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<PrintLinksCubit>()..getPrintLinks(sectionId),
      child: BlocBuilder<PrintLinksCubit, PrintLinksState>(
        builder: (context, state) {
          if (state is PrintLinksLoading) {
            return const Center(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(strokeWidth: 2),
            ));
          } else if (state is PrintLinksError) {
             // Silently fail or show empty if needed, or show error
             return const SizedBox();
          } else if (state is PrintLinksLoaded) {
            final data = state.data;
            if (data.withAnswersUrl == null && data.withoutAnswersUrl == null) {
              return const SizedBox();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
              child: Column(
                children: [
                  if (data.withoutAnswersUrl != null && data.withoutAnswersUrl!.isNotEmpty)
                    _buildPdfItem(context, 'نسخة غير محلولة', data.withoutAnswersUrl!),
                  
                  if (data.withAnswersUrl != null && data.withAnswersUrl!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildPdfItem(context, 'نسخة محلولة', data.withAnswersUrl!, isSolved: true),
                  ],
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildPdfItem(BuildContext context, String title, String url, {bool isSolved = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
           BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSolved ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.picture_as_pdf, 
            color: isSolved ? Colors.green : Colors.red,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        trailing: const Icon(Icons.download_rounded, color: AppColors.primary),
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
             await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
      ),
    );
  }
}
