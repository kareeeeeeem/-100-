import 'package:flutter/material.dart';
import 'package:lms/core/utils/app_colors.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  final _alignDuration = const Duration(milliseconds: 300);
  late AnimationController _alignmentController;
  late Animation<AlignmentDirectional> _startToEndAnimation;
  late Animation<AlignmentDirectional> _endToStartAnimation;
  final ValueNotifier<bool> _isForward = ValueNotifier(false);
  final _firstColor = AppColors.primary;
  final _secondColor = Colors.white.withValues(alpha: 0.7);

  @override
  void initState() {
    _alignmentController = AnimationController(
      vsync: this,
      duration: _alignDuration,
    );

    _startToEndAnimation = Tween(
      begin: AlignmentDirectional.centerStart,
      end: AlignmentDirectional.centerEnd,
    ).animate(_alignmentController);

    _endToStartAnimation = Tween(
      begin: AlignmentDirectional.centerEnd,
      end: AlignmentDirectional.centerStart,
    ).animate(_alignmentController);

    _alignmentController.addStatusListener(_alignAnimationListener);
    _alignmentController.repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _alignmentController.removeStatusListener(_alignAnimationListener);
    _alignmentController.dispose();
    _isForward.dispose();
    super.dispose();
  }

  void _alignAnimationListener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
        setState(() {
          _isForward.value = true;
        });
      case AnimationStatus.reverse:
        setState(() {
          _isForward.value = false;
        });
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isForward,
      builder: (BuildContext context, bool value, _) {
        if (value) {
          return SizedBox(
            width: (60 * 2) + 2,
            height: (60 * 2) + 2,
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _alignmentController,
                  builder: (context, _) {
                    return Align(
                      alignment: _endToStartAnimation.value,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _firstColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _alignmentController,
                  builder: (context, _) {
                    return Align(
                      alignment: _startToEndAnimation.value,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _secondColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return SizedBox(
          width: (60 * 2) + 2,
          height: (60 * 2) + 2,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _alignmentController,
                builder: (context, _) {
                  return Align(
                    alignment: _startToEndAnimation.value,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _secondColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _alignmentController,
                builder: (context, _) {
                  return Align(
                    alignment: _endToStartAnimation.value,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _firstColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
