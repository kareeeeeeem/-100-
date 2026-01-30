import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lms/core/service/cache_service.dart';

class SecureCacheService implements CacheService {
  final FlutterSecureStorage secureStorage;

  SecureCacheService(this.secureStorage);

  @override
  Future<void> set<T>(String key, T value) async {
    secureStorage.write(key: key, value: value?.toString());
  }

  @override
  Future<T?> get<T>(String key) async {
    String? value = await secureStorage.read(key: key);
    if (T == int) {
      return int.tryParse(value ?? '') as T?;
    } else if (T == double) {
      return double.tryParse(value ?? '') as T?;
    } else if (T == bool) {
      return bool.tryParse(value ?? '') as T?;
    } else if (T == String) {
      return value as T?;
    } else {
      throw Exception('Unsupported type: $T');
    }
  }

  @override
  Future<void> remove(String key) async {
    await secureStorage.delete(key: key);
  }

  @override
  Future<void> clearAll() async {
    await secureStorage.deleteAll();
  }
}
