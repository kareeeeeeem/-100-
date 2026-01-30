import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lms/features/on_boarding/data/data_sources/on_boarding_cache_service.dart';
import 'package:lms/features/on_boarding/domain/repository/on_boarding_repository.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  final OnBoardingCacheService onBoardingCacheService;

  OnBoardingRepositoryImpl(this.onBoardingCacheService);

  @override
  Future<void> completeOnBoarding() async {
    try {
      onBoardingCacheService.completeOnBoarding();
    } catch (e) {
      if (kDebugMode) {
        log('Failed to set on boarding completed: $e', name: toString());
      }
    }
  }

  @override
  Future<bool> isOnBoardingCompleted() async {
    try {
      bool? result = await onBoardingCacheService.isOnBoardingCompleted();
      return result ?? false;
    } catch (e) {
      return false;
    }
  }
}
