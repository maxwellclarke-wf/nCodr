library web_watcher;

// redstone import must be first in order to register services
import 'package:redstone/redstone.dart' as app;
import 'packages/web_watcher/services.dart' as services;
import 'dart:io';



main() {
  String testFilesPath = Directory.current.parent.parent.path + '/test/test_files';
  print(Directory.current.path);
  print(new Directory('${Directory.current.path}/../../..').path);
  services.start('${testFilesPath}/input_files', '${testFilesPath}/output_files');
}