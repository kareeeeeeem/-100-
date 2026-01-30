import 'package:lms/core/service/jwt_service.dart';
import 'package:lms/features/splash/domain/repository/splash_repository.dart';
class SplashRepositoryImpl implements SplashRepository {
  final JwtService jwtService;

  SplashRepositoryImpl(this.jwtService);

  @override
  Future<bool> isUserLoggedIn() async {
    return await jwtService.isUserLoggedIn();
  }

  // ضيف الدالة دي في الـ Interface (splash_repository.dart) وهنا كمان
  @override
  Future<String?> getUserType() async {
    return await jwtService.getUserType(); // بنجيب النوع اللي حفظناه وقت اللوجن
  }
@override
Future<String?> getUserName() async {
  return await jwtService.getUserName(); // كدة صح 100%
}
}