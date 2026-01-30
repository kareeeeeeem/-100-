abstract class SplashRepository {
  Future<bool> isUserLoggedIn();
  Future<String?> getUserType(); // لازم تزيد السطر ده هنا
  Future<String?> getUserName();
}
