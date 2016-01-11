import 'package:test/test.dart';
import 'package:web_watcher/watcher.dart';
import 'package:web_watcher/watcher/config.dart';

import 'dart:io';

void main() {
  test('FileSystemWatcher returns files in directory', () {
    print(Directory.current.path);
    //new FileSystemWatcher(new Config('${Directory.current}/../../test/test_files/input_files', new Duration(seconds: 15)));
  });
}


