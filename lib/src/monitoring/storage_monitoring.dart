import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storage/local_storage.dart';

class ASMonitoring extends StatefulWidget {
  const ASMonitoring({Key? key}) : super(key: key);

  @override
  State<ASMonitoring> createState() => _ASMonitoringState();
}

class _ASMonitoringState extends State<ASMonitoring>
    with TickerProviderStateMixin {
  late TabController _primaryController;
  late TabController _fileTabController;

  @override
  void initState() {
    super.initState();

    _primaryController = TabController(length: 2, vsync: this);
    _fileTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _fileTabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Local Storage Monitoring"),
        actions: [
          TextButton(
            onPressed: () async {
              if (_primaryController.index == 0) {
                await LocalStorage.shared.clear();
              } else {
                await LocalStorage.shared.file.removeAll(type: _getType());
              }

              setState(() => {});
            },
            child: Text(
              "Clear",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _getContent(),
      ),
    );
  }

  Widget _getContent() {
    return Column(
      children: [
        TabBar(
          tabs: [
            Tab(
              child: Text(
                "Default",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
            Tab(
              child: Text(
                "File",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            )
          ],
          controller: _primaryController,
        ),
        Expanded(
          child: TabBarView(
            children: [
              _getDefaultContent(),
              _getFileTabs(),
            ],
            controller: _primaryController,
          ),
        )
      ],
    );
  }

  Widget _getDefaultContent() {
    return FutureBuilder<Map<String, String>>(
      future: LocalStorage.shared.getAllData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _getLoading();
        }

        if (!snapshot.hasData || (snapshot.data ?? {}).isEmpty) {
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

  Widget _getFileTabs() {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            children: [
              _getFileContent(type: StorageDirectoryType.temporary),
              _getFileContent(type: StorageDirectoryType.applicationSupport),
              _getFileContent(type: StorageDirectoryType.applicationDocuments),
            ],
            controller: _fileTabController,
          ),
        ),
        TabBar(
          tabs: [
            Tab(
              child: Text(
                "Temporary Directory",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                "Application Support",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                "Application Document",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
          controller: _fileTabController,
        )
      ],
    );
  }

  Widget _getFileContent({
    required StorageDirectoryType type,
  }) {
    return FutureBuilder<List<File>>(
      future: LocalStorage.shared.file.getAll(type: type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _getLoading();
        }

        if (!snapshot.hasData || (snapshot.data ?? []).isEmpty) {
          return _getEmpty();
        }

        List<Widget> widgets = snapshot.data?.map((e) {
              return GestureDetector(
                child: ListTile(
                  title: Text(e.path.split("/").last),
                  subtitle: Text(e.path),
                ),
                onTap: () async {
                  Widget widget;

                  if (_isImage(e)) {
                    widget = Image.file(e);
                  } else {
                    String value = await e.readAsString();

                    widget = SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: jsonDecode(value).toString(),
                                ),
                              );
                              _showSnackBar('Value is copied to clipboard!');
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                "Copy",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            jsonDecode(value).toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  _showBottomSheet(widget);
                },
              );
            }).toList() ??
            [];

        return ListView(
          children: widgets,
        );
      },
    );
  }

  StorageDirectoryType _getType() {
    if (_fileTabController.index == 0) {
      return StorageDirectoryType.temporary;
    } else if (_fileTabController.index == 1) {
      return StorageDirectoryType.applicationSupport;
    } else {
      return StorageDirectoryType.applicationDocuments;
    }
  }

  bool _isImage(File file) {
    String extension = file.path.split("/").last.split(".").last;
    List<String> imageExtensions = ["jpg", "jpeg", "png", "gif", "webp"];
    return imageExtensions.contains(extension.toLowerCase());
  }

  Widget _getEmpty() {
    return Center(
      child: Text("No data found"),
    );
  }

  Widget _getLoading() {
    return Center(
      child: Text("Loading ..."),
    );
  }

  void _showSnackBar(String title) {
    SnackBar snackBar = SnackBar(
      content: Text(title),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showBottomSheet(Widget content) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 4,
                    width: 60,
                    color: Colors.black26,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Value',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
              Expanded(child: content),
            ],
          ),
        );
      },
    );
  }
}
