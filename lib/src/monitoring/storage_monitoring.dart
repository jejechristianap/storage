import 'package:flutter/material.dart';
import 'package:storage/local_storage.dart';

class StorageMonitoring extends StatelessWidget {
  const StorageMonitoring({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Storage Monitoring"),
      ),
      body: SafeArea(
        child: _getContent(),
      ),
    );
  }

  Widget _getContent() {
    return FutureBuilder<Map<String, String>>(
      future: LocalStorage.shared.getAllData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _getLoading();
        }

        if (!snapshot.hasData) {
          return _getEmpty();
        }

        List<ListTile> widgets = snapshot.data?.keys.map((e) {
          return ListTile(
            title: Text(e),
            subtitle: Text(snapshot.data?[e] ?? "-"),
          );
        }).toList() ??
            [];

        return ListView(
          children: widgets,
        );
      },
    );
  }

  Widget _getEmpty() {
    return const Center(
      child: Text("No data found"),
    );
  }

  Widget _getLoading() {
    return const Center(
      child: Text("Loading ..."),
    );
  }
}
