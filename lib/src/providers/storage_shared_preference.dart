import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/src/contracts/storage_provider.dart';
import 'package:storage/src/models/storage_model.dart';

class StorageSharedPreference implements StorageProvider{
  SharedPreferences? _instance;

  Future<SharedPreferences> _getInstance() async {
    if (_instance != null) {
      return Future.value(_instance);
    } else {
      _instance = await SharedPreferences.getInstance();
      return Future.value(_instance);
    }
  }

  @override
  Future<StorageModel> get(String key) async {
    var instance = await _getInstance();
    return StorageModel(instance.get(key));
  }

  @override
  Future set({required String key, required Object value}) async {
    var instance = await _getInstance();
    if (value is String) {
      return instance.setString(key, value);
    } else if (value is int) {
      return instance.setInt(key, value);
    } else if (value is double) {
      return instance.setDouble(key, value);
    } else if (value is bool) {
      return instance.setBool(key, value);
    } else if (value is List || value is Map) {
      try {
        String json = jsonEncode(value);
        instance.setString(key, json);
      } catch (error) {
        throw "Unsupported Data Type";
      }
    } else {
      throw "Unsupported Data Type";
    }
  }

  @override
  Future<bool> remove({required String key}) async {
    var instance = await _getInstance();
    return instance.remove(key);
  }

  @override
  Future<bool> clear() async {
    var instance = await _getInstance();
    return instance.clear();
  }

  @override
  Future<Map<String, String>> getAllData() async {
    var instance = await _getInstance();
    Map<String, String> result = <String, String>{};

    instance.getKeys().forEach((element) {
      Object? value = instance.get(element);

      if (value != null) {
        if (value is String) {
          result[element] = value;
        } else {
          result[element] = jsonEncode(value);
        }
      }
    });

    return result;
  }
}
