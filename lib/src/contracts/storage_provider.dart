import 'package:storage/src/models/storage_model.dart';

abstract class StorageProvider {
  /// Getter
  ///
  /// @param:
  /// [key] : [String]
  ///
  /// @return: Future<ASModel>

  Future<StorageModel> get(String key);

  /// Setter
  /// If you need to immediately get the data from storage right after
  /// writing it, please use await.
  ///
  /// @param:
  /// [key] : [String]
  /// [value] : [Object]

  Future set({required String key, required Object value});

  /// Remove Value
  /// Remove value for given key
  ///
  /// @param:
  /// [key] : [String]
  ///
  /// @return: Future<bool>

  Future<bool> remove({required String key});

  /// Clear All Key and Values
  ///
  /// @return: Future<bool>

  Future<bool> clear();

  /// Get All Key and Values
  ///
  /// @return: Future<Map<String, String>>

  Future<Map<String, String>> getAllData();
}
