import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lms/core/network/service/api_service.dart';
import 'package:lms/core/service/cache_service.dart';
import 'package:lms/core/service/jwt_service.dart';

// --- الحالات (States) ---
abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<dynamic> courses;
  WishlistLoaded(this.courses);
}

class WishlistToggleSuccess extends WishlistState {
  final int courseId;
  final bool isFavorited;
  final String message;
  final List<dynamic> courses;
  WishlistToggleSuccess(this.courseId, this.isFavorited, this.message, this.courses);
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);
}

// --- الكيوبيت (Cubit) ---
class WishlistCubit extends Cubit<WishlistState> {
  final ApiService _apiService = GetIt.instance<ApiService>();
  final JwtService _jwtService = GetIt.instance<JwtService>();
  final CacheService _cacheService;

  static const String _favKey = 'local_favorited_ids';
  static const String _unfavKey = 'local_unfavorited_ids';

  // للمحافظة على الحالة حتى لو السيرفر اتأخر في الرد بـ GET
  final Set<int> _favoritedIds = {};
  final Set<int> _unfavoritedIds = {};

  WishlistCubit(this._cacheService) : super(WishlistInitial()) {
    _loadLocalState();
  }

  Future<void> _loadLocalState() async {
    try {
      final List<String>? favs = await _cacheService.get<List<String>>(_favKey);
      final List<String>? unfavs = await _cacheService.get<List<String>>(_unfavKey);

      if (favs != null) {
        _favoritedIds.addAll(favs.map((id) => int.tryParse(id) ?? 0).where((id) => id != 0));
      }
      if (unfavs != null) {
        _unfavoritedIds.addAll(unfavs.map((id) => int.tryParse(id) ?? 0).where((id) => id != 0));
      }
      print("📦 [WishlistCubit] Local State Loaded: Favs=$_favoritedIds, Unfavs=$_unfavoritedIds");
    } catch (e) {
      print("⚠️ [WishlistCubit] Error loading local state: $e");
    }
  }

  Future<void> _saveLocalState() async {
    try {
      await _cacheService.set(_favKey, _favoritedIds.map((id) => id.toString()).toList());
      await _cacheService.set(_unfavKey, _unfavoritedIds.map((id) => id.toString()).toList());
    } catch (e) {
      print("⚠️ [WishlistCubit] Error saving local state: $e");
    }
  }

  Future<void> toggleFavorite(int courseId) async {
    try {
      print("🚀 [WishlistCubit] toggleFavorite requested for ID: $courseId");
      final String? token = await _jwtService.getAccessToken();
      
      if (token == null) {
        emit(WishlistError("يجب تسجيل الدخول أولاً"));
        return;
      }

      final response = await _apiService.post(
        'favorites/toggle',
        body: {'course_id': courseId},
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("📥 [WishlistCubit] Response: $response");

      if (response['status'] == true) {
        final isFavorited = response['data']['is_favorited'];
        
        // تحديث الحالة المحلية فوراً
        if (isFavorited) {
          _favoritedIds.add(courseId);
          _unfavoritedIds.remove(courseId);
        } else {
          _unfavoritedIds.add(courseId);
          _favoritedIds.remove(courseId);
        }

        // حفظ الحالة محلياً
        await _saveLocalState();

        List<dynamic> currentCourses = [];
        if (state is WishlistLoaded) {
          currentCourses = (state as WishlistLoaded).courses;
        }

        final updatedCourses = currentCourses.where((c) {
          final dynamic rawId = c['id'] ?? c['course_id'];
          final int id = rawId is int ? rawId : (int.tryParse(rawId?.toString() ?? '') ?? 0);
          return id != courseId;
        }).toList();

        emit(WishlistToggleSuccess(courseId, isFavorited, response['message'] ?? "", updatedCourses));
        
        // تحديث القائمة في الخلفية
        await getWishlist(isBackground: true); 
      } else {
        emit(WishlistError(response['message'] ?? "فشل تحديث المفضلة"));
      }
    } catch (e) {
      print("💣 [WishlistCubit] EXCEPTION (Toggle): $e");
      emit(WishlistError("حدث خطأ في الاتصال"));
    }
  }

  Future<void> getWishlist({bool isBackground = false}) async {
    try {
      final String? token = await _jwtService.getAccessToken();
      if (token == null) return;

      if (!isBackground) emit(WishlistLoading());
      
      // جلب الكورسات العادية المفضلة
      dynamic regularResponse;
      try {
        regularResponse = await _apiService.get(
          'courses?is_favorited=1',
          headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
        );
        print("📥 [WishlistCubit] Get Favorites Response: $regularResponse");
      } catch (_) {}

      // جلب بيانات الهوم لاستخراج الكورسات القادمة (Upcoming) المفضلة
      // لأنها ساعات مش بتظهر في الـ Endpoint العادي
      dynamic homeResponse;
      try {
        homeResponse = await _apiService.get(
          'home',
          headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
        );
      } catch (_) {}

      List<dynamic> allFavorited = [];

      // 1. إضافة الكورسات العادية
      if (regularResponse != null && regularResponse['status'] == true) {
        final data = regularResponse['data'];
        if (data is List) {
          allFavorited.addAll(data);
        }
      }

      // 2. إضافة الكورسات القادمة المفضلة من الهوم
      if (homeResponse != null && homeResponse['status'] == true) {
        final upcoming = homeResponse['data']?['upcoming_courses'];
        if (upcoming is List) {
          final favoritedUpcoming = upcoming.where((c) {
            // نتحقق لو الكورس معمول له Favorite في الهوم
            // أو لو المستخدم لسه عامل له Favorite في الجلسة الحالية
            final dynamic rawId = c['id'] ?? c['course_id'];
            final int id = rawId is int ? rawId : (int.tryParse(rawId?.toString() ?? '') ?? 0);
            
            final bool isFavInHome = c['is_favorited'] ?? false;
            final bool isNewlyFav = _favoritedIds.contains(id);
            final bool isUnfavored = _unfavoritedIds.contains(id);
            
            // الـ local override (Unfavored) له الأولوية القصوى
            if (isUnfavored) return false;
            return (isFavInHome || isNewlyFav);
          }).toList();
          
          // دمجهم بدون تكرار
          for (var course in favoritedUpcoming) {
            final dynamic rawId = course['id'] ?? course['course_id'];
            final int id = rawId is int ? rawId : (int.tryParse(rawId?.toString() ?? '') ?? 0);
            
            if (!allFavorited.any((existing) {
              final dynamic eId = existing['id'] ?? existing['course_id'];
              return (eId is int ? eId : int.tryParse(eId.toString())) == id;
            })) {
              allFavorited.add(course);
            }
          }
        }
      }

      // 3. تصفية نهائية بناءً على الـ IDs اللي اتمسحت في الجلسة الحالية أو محلياً
      final finalCourses = allFavorited.where((c) {
        final dynamic rawId = c['id'] ?? c['course_id'];
        final int id = rawId is int ? rawId : (int.tryParse(rawId?.toString() ?? '') ?? 0);
        return !_unfavoritedIds.contains(id);
      }).toList();

      emit(WishlistLoaded(finalCourses));
      
    } catch (e) {
      print("💣 [WishlistCubit] getWishlist EXCEPTION: $e");
      if (!isBackground) emit(WishlistError("فشل تحميل المفضلة"));
    }
  }

  bool isCourseFavorited(int courseId, bool initialIsFavorited) {
    if (_favoritedIds.contains(courseId)) return true;
    if (_unfavoritedIds.contains(courseId)) return false;
    return initialIsFavorited;
  }
}