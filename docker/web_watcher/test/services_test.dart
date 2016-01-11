import 'package:redstone/redstone.dart' as app;
import 'package:test/test.dart';
import 'package:web_watcher/services.dart' as services;
import 'dart:io';

main() async {
  String testFilesPath = Directory.current.parent.parent.path + '/test/test_files';
  print(Directory.current.path);
  print(new Directory('${Directory.current.path}/../../..').path);
  services.start('${testFilesPath}/input_files', '${testFilesPath}/output_files');
  setUp(app.redstoneSetUp);
  tearDown(app.redstoneTearDown);

  test("/fetch", () async {
    var req = new app.MockRequest("/fetch");
    await services.outputStore.stream.first;
    await services.inputStore.stream.first;

    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(200));
      print('${resp.mockContent} :: ${resp.mockContent.runtimeType}');
      expect(resp.mockContent, equals("a list"));
    });
  });
}