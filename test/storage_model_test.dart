import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:storage/src/models/storage_model.dart';

void main() {
  test("Test String Value", () {
    String value = "This is String";
    StorageModel stringModel = StorageModel(value);
    StorageModel nonStringModel = StorageModel(0);

    expect(stringModel.getString(), value);
    expect(stringModel.getStringValue(), value);
    expect(nonStringModel.getString(), null);
    expect(nonStringModel.getStringValue(), "");
  });

  test("Test Integer Value", () {
    int value = 123;
    StorageModel intModel = StorageModel(value);
    StorageModel nonIntModel = StorageModel("string");

    expect(intModel.getInt(), value);
    expect(intModel.getIntValue(), value);
    expect(nonIntModel.getInt(), null);
    expect(nonIntModel.getIntValue(), 0);
  });

  test("Test Double Value", () {
    double value = 123.0;
    StorageModel doubleModel = StorageModel(value);
    StorageModel nonDoubleModel = StorageModel(false);

    expect(doubleModel.getDouble(), value);
    expect(doubleModel.getDoubleValue(), value);
    expect(nonDoubleModel.getDouble(), null);
    expect(nonDoubleModel.getDoubleValue(), 0.0);
  });

  test("Test Boolean Value", () {
    bool value = true;
    StorageModel boolModel = StorageModel(value);
    StorageModel nonBoolModel = StorageModel([123456]);

    expect(boolModel.getBool(), value);
    expect(boolModel.getBoolValue(), value);
    expect(nonBoolModel.getBool(), null);
    expect(nonBoolModel.getBoolValue(), false);
  });

  test("Test List of String Value", () {
    List<String> value = ["Hello", "World"];
    String stringValue = jsonEncode(value);
    StorageModel listModel = StorageModel(stringValue);
    StorageModel nonListModel = StorageModel([1]);

    expect(listModel.getList<String>(), value);
    expect(listModel.getListValue<String>(), value);
    expect(nonListModel.getList<String>(), null);
    expect(nonListModel.getListValue<String>(), <String>[]);
  });

  test("Test List of dynamic value", () {
    List<dynamic> value = ["hello", 1, "world"];
    String stringValue = jsonEncode(value);
    StorageModel listModel = StorageModel(stringValue);
    StorageModel nonListModel = StorageModel([1]);

    expect(listModel.getList<dynamic>(), value);
    expect(listModel.getListValue<dynamic>(), value);
    expect(nonListModel.getList<dynamic>(), null);
    expect(nonListModel.getListValue<dynamic>(), <dynamic>[]);
    expect(listModel.getList<String>(), null);
  });

  test("Test List of number value", () {
    List<int> value = [1, 2];
    String stringValue = jsonEncode(value);
    StorageModel listModel = StorageModel(stringValue);
    StorageModel nonListModel = StorageModel(false);

    expect(listModel.getList<int>(), value);
    expect(listModel.getListValue<int>(), value);
    expect(nonListModel.getList<int>(), null);
    expect(nonListModel.getListValue<int>(), <int>[]);
  });

  test("Test Map of String Dynamic Value", () {
    Map<String, dynamic> value = {"foo": "bar"};
    String stringValue = jsonEncode(value);
    StorageModel mapModel = StorageModel(stringValue);
    StorageModel nonMapModel = StorageModel(1.0);

    expect(mapModel.getMap<dynamic>(), value);
    expect(mapModel.getMapValue<dynamic>(), value);
    expect(nonMapModel.getMap<dynamic>(), null);
    expect(nonMapModel.getMapValue<dynamic>(), <String, dynamic>{});
  });

  test("Value is null", () {
    StorageModel nullModel = StorageModel(null);

    expect(nullModel.getInt(), null);
    expect(nullModel.getIntValue(), 0);
    expect(nullModel.getStringValue(), "");
    expect(nullModel.getBoolValue(), false);
    expect(nullModel.getDoubleValue(), 0.0);
    expect(nullModel.getListValue<String>(), <String>[]);
  });
}
