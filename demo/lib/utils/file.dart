import 'package:demo/utils/log.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

final FileUtil fileUtil = FileUtil();

class FileUtil {
  Future<Directory?>? _tempDirectory;
  Future<Directory?>? _appSupportDirectory;
  Future<Directory?>? _appLibraryDirectory;
  Future<Directory?>? _appDocumentsDirectory;
  Future<Directory?>? _externalDocumentsDirectory;
  Future<List<Directory>?>? _externalStorageDirectories;
  Future<List<Directory>?>? _externalCacheDirectories;
  Future<Directory?>? _downloadsDirectory;



  FileUtil() {
    // _tempDirectory = getTemporaryDirectory();
    // _appDocumentsDirectory = getApplicationDocumentsDirectory();
    // _appSupportDirectory = getApplicationSupportDirectory();
    // _appLibraryDirectory = getLibraryDirectory();
    // _externalDocumentsDirectory = getExternalStorageDirectory();
    // _externalStorageDirectories =
    //     getExternalStorageDirectories(type: StorageDirectory.music);
    // _externalCacheDirectories = getExternalCacheDirectories();
    // _downloadsDirectory = getDownloadsDirectory();
    // logUtil.d(_tempDirectory);
  }
}
