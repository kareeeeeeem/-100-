abstract class JwtService {
  Future<void> saveAccessToken(String accessToken);

  Future<String?> getAccessToken();

  Future<void> saveRefreshToken(String refreshToken);

  Future<String?> getRefreshToken();

  Future<bool> isUserLoggedIn();

  Future<void> deleteAccessToken();

  Future<void> deleteRefreshToken();

  Future<void> saveUserType(String userType); // ضيف ده
  Future<String?> getUserType();      
  
  Future<void> saveUserName(String userName);
  Future<String?> getUserName();
  Future<void> clearAll();
}
