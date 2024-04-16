library storage;

import 'package:storage/src/contracts/storage_provider.dart';
import 'package:storage/src/models/storage_model.dart';
import 'package:storage/src/providers/storage_file.dart';
import 'package:storage/src/providers/storage_shared_preference.dart';

export 'src/monitoring/storage_monitoring.dart';
export 'src/enums/storage_directory_type.dart';

class LocalStorage {
  static LocalStorage shared = LocalStorage();
  final StorageProvider _provider = StorageSharedPreference();
  final StorageFile file = StorageFile();

  Future<StorageModel> get(String key) {
    return _provider.get(key);
  }

  Future set({required String key, required Object value}) {
    return _provider.set(key: key, value: value);
  }

  Future<bool> remove({required String key}) {
    return _provider.remove(key: key);
  }

  Future<bool> clear() {
    return _provider.clear();
  }

  Future<Map<String, String>> getAllData() {
    return _provider.getAllData();
  }
}
