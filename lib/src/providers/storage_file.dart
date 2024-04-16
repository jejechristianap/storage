import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:storage/src/enums/storage_directory_type.dart';

class StorageFile {
  final String _dataKey = "data";
  final String _expireAtKey = "expireAt";
  final String _filePrefix = "agriaku_storage_";

  String get defaultPrefix => _filePrefix;

  Future<String?> save({
    required String fileName,
    required String value,
    StorageDirectoryType type = StorageDirectoryType.temporary,
    DateTime? expiredAt,
  }) async {
    try {
      Directory directory = await _getDirectory(type: type);
      String filePath = "${directory.path}/$_filePrefix$fileName";
      File file = File(filePath);
      Map<String, dynamic> data = {
        _dataKey: value,
      };
      JsonEncoder encoder = const JsonEncoder.withIndent("  ");

      if (expiredAt != null) {
        data[_expireAtKey] = expiredAt.millisecondsSinceEpoch;
      }

      await file.writeAsString(encoder.convert(data));

      return filePath;
    } catch (e) {
      debugPrint(e.toString());
      // for now we just return null. next phase we need to handle out of storage
      return null;
    }
  }

  Future<String?> saveFile({
    required File file,
    StorageDirectoryType type = StorageDirectoryType.temporary,
  }) async {
    try {
      Directory directory = await _getDirectory(type: type);
      String fileName = file.path.split("/").last;
      String newPath = "${directory.path}/$_filePrefix$fileName";
      await file.copy(newPath);

      return newPath;
    } catch (e) {
      debugPrint(e.toString());
      // for now we just return null. next phase we need to handle out of storage
      return null;
    }
  }

  Future<String> get({
    required String fileName,
    StorageDirectoryType type = StorageDirectoryType.temporary,
  }) async {
    try {
      Directory directory = await _getDirectory(type: type);
      String filePath;

      if (fileName.contains(_filePrefix)) {
        filePath = "${directory.path}/$fileName";
      } else {
        filePath = "${directory.path}/$_filePrefix$fileName";
      }

      File file = File(filePath);
      Map<String, dynamic> results = jsonDecode(await file.readAsString());

      return results[_dataKey];
    } catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }

  Future<void> remove({
    required String fileName,
    StorageDirectoryType type = StorageDirectoryType.temporary,
  }) async {
    try {
      if (!fileName.startsWith(_filePrefix)) {
        fileName = '$_filePrefix$fileName';
      }

      Directory directory = await _getDirectory(type: type);
      String filePath = '${directory.path}/$fileName';
      File file = File(filePath);

      await file.delete();
    } catch (e) {
      debugPrint(e.toString());
      // for now we can do nothing. next phase we need to handle the error;
    }
  }

  Future<List<File>> getAll({
    StorageDirectoryType type = StorageDirectoryType.temporary,
  }) async {
    try {
      Directory directory = await _getDirectory(type: type);
      String directoryPath = directory.path;

      return Directory(directoryPath)
          .listSync()
          .map((e) => File(e.path))
          .where((element) => element.path.contains(_filePrefix))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<void> removeAll({
    StorageDirectoryType type = StorageDirectoryType.temporary,
  }) async {
    List<File> files = await getAll(type: type);

    for (File file in files) {
      await file.delete();
    }
  }

  Future<void> removeAllExpired({
    StorageDirectoryType type = StorageDirectoryType.temporary,
  }) async {
    List<File> files = await getAll(type: type);

    for (File file in files) {
      Map<String, dynamic> results = jsonDecode(await file.readAsString());
      int? milis = results[_expireAtKey];

      if (milis != null &&
          DateTime.fromMillisecondsSinceEpoch(milis).isBefore(DateTime.now())) {
        await file.delete();
      }
    }
  }

  Future<Directory> _getDirectory({
    required StorageDirectoryType type,
  }) {
    switch (type) {
      case StorageDirectoryType.temporary:
        return getTemporaryDirectory();
      case StorageDirectoryType.applicationSupport:
        return getApplicationSupportDirectory();
      case StorageDirectoryType.applicationDocuments:
        return getApplicationDocumentsDirectory();
    }
  }
}
