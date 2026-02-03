import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/core/widgets/custom_container.dart';
import 'package:lms/features/son_flow/live_sessions/presentation/manager/live_session_cubit.dart';
import 'package:lms/features/son_flow/live_sessions/presentation/manager/live_session_state.dart';
import 'package:lms/features/son_flow/live_sessions/data/models/live_session_model.dart';

class AvailableLivesPage extends StatefulWidget {
  const AvailableLivesPage({super.key});

  @override
  State<AvailableLivesPage> createState() => _AvailableLivesPageState();
}

class _AvailableLivesPageState extends State<AvailableLivesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LiveSessionCubit, LiveSessionState>(
      listener: (context, state) async {
        if (state is LiveSessionJoined) {
          final uri = Uri.parse(state.joinData.joinUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تعذر فتح الرابط: ${state.joinData.joinUrl}'), backgroundColor: Colors.red),
              );
            }
          }
        } else if (state is LiveSessionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is LiveSessionJoining) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('جاري تجهيز رابط الانضمام...'), duration: Duration(seconds: 1)),
          );
        }
      },
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: const Text('البثوث المتاحة'),
            ),
            body: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, LiveSessionState state) {
    if (state is LiveSessionLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    LiveSessionsDataModel? sessions;
    if (state is LiveSessionsLoaded) {
      sessions = state.sessions;
    } else if (state is LiveSessionJoining) {
      sessions = state.currentSessions;
    } else if (state is LiveSessionJoined) {
      sessions = state.currentSessions;
    }

    if (sessions != null) {
      final data = sessions;
      return Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomContainer(
              borderWidth: 0.4,
              borderAlpha: 0.2,
              borderRadius: 8.99,
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                labelColor: Colors.white,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(9),
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                tabAlignment: TabAlignment.fill,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(8),
                labelPadding: const EdgeInsets.all(8),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [Text('المتاح الآن'), Text('تمت مشاهدته')],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              children: [
                _buildLiveGrid(data.availableNow),
                _buildLiveGrid(data.archived),
              ],
            ),
          ),
        ],
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('حدث خطأ ما أو لا توجد بيانات'),
          ElevatedButton(
            onPressed: () => context.read<LiveSessionCubit>().loadLiveSessions(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveGrid(List<LiveSessionModel> items) {
    if (items.isEmpty) {
      return const Center(child: Text('لا توجد بثوث في هذا القسم'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 35,
        crossAxisSpacing: 20,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () {
            context.read<LiveSessionCubit>().joinSession(item.id.toString());
          },
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(31.45),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(31.45),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(31.45),
                        child: (item.thumbnail != null && item.thumbnail!.isNotEmpty)
                            ? Image.network(
                                item.thumbnail!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => AppImages.live.image(fit: BoxFit.contain),
                              )
                            : AppImages.live.image(fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                left: 5,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: AppColors.c4DC9D1,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.video_camera_back,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                child: SizedBox(
                  width: 90,
                  child: Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}