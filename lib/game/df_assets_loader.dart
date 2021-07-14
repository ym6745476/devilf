import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;

/// 资源加载和缓存管理
class DFAssetsLoader {
  /// 缓存管理
  static final Map<String, dynamic> _files = {};

  DFAssetsLoader();

  /// 从Cache删除文件
  static void clear(String file) {
    _files.remove(file);
  }

  /// 清空缓存
  static void clearCache() {
    _files.clear();
  }

  /// 读取图片
  static Future<ui.Image> loadImage(String src) async {
    if (!_files.containsKey(src)) {
      final data = await rootBundle.load(src);
      final bytes = Uint8List.view(data.buffer);
      final completer = Completer<ui.Image>();
      ui.decodeImageFromList(bytes, completer.complete);
      _files[src] = completer.future;
    }
    return _files[src] as Future<ui.Image>;
  }

  /// 读取文本文件
  static Future<String> loadText(String src) async {
    if (!_files.containsKey(src)) {
      _files[src] = await rootBundle.loadString(src);
    }
    return _files[src] as String;
  }

  /// 读取Json文件
  static Future<Map<String, dynamic>> loadJson(String src) async {
    final content = await rootBundle.loadString(src);
    return jsonDecode(content) as Map<String, dynamic>;
  }
}
