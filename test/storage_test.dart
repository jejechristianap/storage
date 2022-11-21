import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/src/models/storage_model.dart';

import 'package:storage/local_storage.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test("Test undefined value", () async {
    String key = "key";
    StorageModel result = await LocalStorage.shared.get(key);
    expect(result.getStringValue(), "");
    expect(result.getListValue(), []);
    expect(result.getMapValue(), {});
    expect(result.getIntValue(), 0);
    expect(result.getBoolValue(), false);
    expect(result.getDoubleValue(), 0.0);
  });

  test("Test store string", () async {
    String value = "String Result";
    String key = "StringKey";

    await LocalStorage.shared.set(key: key, value: value);
    StorageModel result = await LocalStorage.shared.get(key);
    expect(result.getString(), value);
    expect(result.getStringValue(), value);
    expect(result.getInt(), null);
    expect(result.getIntValue(), 0);
  });

  test("Test store list of number", () async {
    List<num> value = [1, 2, 3, 4, 5];
    String key = "numKey";

    await LocalStorage.shared.set(key: key, value: value);
    StorageModel result = await LocalStorage.shared.get(key);
    expect(result.getList<num>(), value);
    expect(result.getListValue<num>(), value);
    expect(result.getListValue<num>().first, 1);
    expect(result.getBool(), null);
    expect(result.getBoolValue(), false);
  });

  test("Test store map of num", () async {
    Map<String, num> value = {"foo": 1, "bar": 2};
    String key = "mapKey";

    await LocalStorage.shared.set(key: key, value: value);
    StorageModel result = await LocalStorage.shared.get(key);
    expect(result.getMap<num>(), value);
    expect(result.getMapValue<num>(), value);
    expect(result.getMapValue<num>()?["foo"], 1);
    expect(result.getDouble(), null);
    expect(result.getDoubleValue(), 0.0);
    expect(result.getMap<bool>(), null);
    expect(result.getMapValue<bool>(), <String, num>{});
  });

  test("Test store map of dynamic", () async {
    Map<String, dynamic> value = {"foo": 1, "bar": "baz"};
    String key = "mapKey";

    await LocalStorage.shared.set(key: key, value: value);
    StorageModel result = await LocalStorage.shared.get(key);
    expect(result.getMap<dynamic>(), value);
    expect(result.getMapValue<dynamic>(), value);
    expect(result.getMapValue<dynamic>()?["foo"], 1);
    expect(result.getMapValue<dynamic>()?["bar"], "baz");
    expect(result.getDouble(), null);
    expect(result.getDoubleValue(), 0.0);
    expect(result.getMap<bool>(), null);
    expect(result.getMapValue<bool>(), <String, dynamic>{});
  });

  test("Test Removing Key", () async {
    int value = 0;
    String key = "intKey";

    await LocalStorage.shared.set(key: key, value: value);
    StorageModel result = await LocalStorage.shared.get(key);
    expect(result.getInt(), value);
    expect(result.getIntValue(), value);
    expect(result.getBool(), null);
    expect(result.getBoolValue(), false);

    bool removeResult = await LocalStorage.shared.remove(key: key);
    StorageModel newResult = await LocalStorage.shared.get(key);
    expect(removeResult, true);
    expect(newResult.getInt(), null);
    expect(newResult.getIntValue(), 0);
  });

  test("Test Clear All Key and Values", () async {
    double value = 24.0;
    String key = "doubleKey";

    await LocalStorage.shared.set(key: key, value: value);
    StorageModel result = await LocalStorage.shared.get(key);
    expect(result.getDouble(), value);
    expect(result.getDoubleValue(), value);
    expect(result.getBool(), null);
    expect(result.getBoolValue(), false);

    bool removeResult = await LocalStorage.shared.clear();
    StorageModel newResult = await LocalStorage.shared.get(key);
    expect(removeResult, true);
    expect(newResult.getDouble(), null);
    expect(newResult.getDoubleValue(), 0.0);
  });

  test("Test get all data", () async {
    String stringValue = "hello";
    String stringKey = "stringKey";
    num numValue = 20;
    String numKey = "numKey";
    List<dynamic> listValue = [1, "foo", 2.0];
    String listKey = "listKey";
    Map<String, double> mapValue = {"foo": 1.0};
    String mapKey = "mapKey";
    Map<String, String> expectedResult = {
      stringKey: stringValue,
      numKey: jsonEncode(numValue),
      listKey: jsonEncode(listValue),
      mapKey: jsonEncode(mapValue),
    };

    await LocalStorage.shared.set(key: stringKey, value: stringValue);
    await LocalStorage.shared.set(key: numKey, value: numValue);
    await LocalStorage.shared.set(key: listKey, value: listValue);
    await LocalStorage.shared.set(key: mapKey, value: mapValue);

    Map<String, String> result = await LocalStorage.shared.getAllData();

    expect(result, expectedResult);
  });
}
