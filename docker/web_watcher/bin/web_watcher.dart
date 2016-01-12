library web_watcher;

// redstone import must be first in order to register services
import 'package:redstone/redstone.dart' as app;
import 'packages/web_watcher/services.dart' as services;
import 'dart:io';



main() {
  String testFilesPath = Directory.current.parent.parent.path + '/test/test_files';
  app.setupConsoleLog();
  services.start('${testFilesPath}/input_files', '${testFilesPath}/output_files');
  app.start(address: 'localhost');
}