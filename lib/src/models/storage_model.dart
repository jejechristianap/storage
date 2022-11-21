import 'dart:convert';

class StorageModel {
  final Object? _object;

  /// Constructors
  ///
  /// @param:
  /// [_object] : [Object]

  StorageModel(this._object);

  /// Getter Optional Integer
  ///
  /// @return: int?

  int? getInt() {
    try {
      return _object as int;
    } catch (_) {
      return null;
    }
  }

  /// Getter Non-Nullable Integer.
  /// When null, will fallback to 0 as default value
  ///
  /// @return: int

  int getIntValue() {
    try {
      return _object as int;
    } catch (_) {
      return 0;
    }
  }

  /// Getter Optional String
  ///
  /// @return: String?

  String? getString() {
    try {
      return _object as String;
    } catch (_) {
      return null;
    }
  }

  /// Getter Non-Nullable String.
  /// When null, will return empty string.
  ///
  /// @return: String

  String getStringValue() {
    try {
      return _object as String;
    } catch (_) {
      return "";
    }
  }

  /// Getter Optional Double
  ///
  /// @return: double?

  double? getDouble() {
    try {
      return _object as double;
    } catch (_) {
      return null;
    }
  }

  /// Getter Non-Nullable Double.
  /// When null, will return 0.0 as default
  ///
  /// @return: double

  double getDoubleValue() {
    try {
      return _object as double;
    } catch (_) {
      return 0.0;
    }
  }

  /// Getter Optional Bool
  ///
  /// @return: bool?

  bool? getBool() {
    try {
      return _object as bool;
    } catch (_) {
      return null;
    }
  }

  /// Getter Non-Nullable Double.
  /// When null, will return `false` as default
  ///
  /// @return: bool

  bool getBoolValue() {
    try {
      return _object as bool;
    } catch (_) {
      return false;
    }
  }

  /// Getter Optional List
  ///
  /// @return: List<T>?

  List<T>? getList<T>() {
    try {
      var stringValue = _object as String;
      List<dynamic> listValue = jsonDecode(stringValue);
      return listValue.map((e) => e as T).toList();
    } catch (_) {
      return null;
    }
  }

  /// Getter Non-Nullable List
  /// When null, will return Empty List of `T` as default
  ///
  /// @return: List<T>

  List<T> getListValue<T>() {
    try {
      var stringValue = _object as String;
      List<dynamic> listValue = jsonDecode(stringValue);
      return listValue.map((e) => e as T).toList();
    } catch (_) {
      return <T>[];
    }
  }

  /// Getter Optional Map
  ///
  /// @return: Map<String, T>

  Map<String, T>? getMap<T>() {
    try {
      var stringValue = _object as String;
      Map<String, dynamic> mapValue = jsonDecode(stringValue);
      return mapValue.map((key, value) => MapEntry(key, value as T));
    } catch (_) {
      return null;
    }
  }

  /// Getter Non-Nullable Map
  /// When null, will return Empty Object of `String` and `T` as default
  ///
  /// @return: Map<String, T>

  Map<String, T>? getMapValue<T>() {
    try {
      var stringValue = _object as String;
      Map<String, dynamic> mapValue = jsonDecode(stringValue);
      return mapValue.map((key, value) => MapEntry(key, value as T));
    } catch (_) {
      return <String, T>{};
    }
  }
}
