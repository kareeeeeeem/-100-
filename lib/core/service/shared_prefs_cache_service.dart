import 'package:shared_preferences/shared_preferences.dart';

import 'package:lms/core/service/cache_service.dart';

class SharedPrefsCacheService implements CacheService {
  final SharedPreferences sharedPreferences;

  SharedPrefsCacheService(this.sharedPreferences);

  @override
  Future<void> set<T>(String key, T value) async {
    if (value is int) {
      await sharedPreferences.setInt(key, value);
    } else if (value is double) {
      await sharedPreferences.setDouble(key, value);
    } else if (value is bool) {
      await sharedPreferences.setBool(key, value);
    } else if (value is String) {
      await sharedPreferences.setString(key, value);
    } else if (value is List<String>) {
      await sharedPreferences.setStringList(key, value);
    } else {
      throw Exception('Unsupported type: ${value.runtimeType}');
    }
  }

  @override
  Future<T?> get<T>(String key) async {
    if (T == int) {
      return sharedPreferences.getInt(key) as T?;
    } else if (T == double) {
      return sharedPreferences.getDouble(key) as T?;
    } else if (T == bool) {
      return sharedPreferences.getBool(key) as T?;
    } else if (T == String) {
      return sharedPreferences.getString(key) as T?;
    } else if (T == List<String>) {
      return sharedPreferences.getStringList(key) as T?;
    } else {
      throw Exception('Unsupported type: $T');
    }
  }

  @override
  Future<void> remove(String key) async {
    await sharedPreferences.remove(key);
  }

  @override
  Future<void> clearAll() async {
    await sharedPreferences.clear();
  }
}
