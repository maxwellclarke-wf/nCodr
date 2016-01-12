import 'package:redstone/redstone.dart' as app;
import 'package:test/test.dart';
import 'package:web_watcher/services.dart' as services;
import 'dart:io';

main() async {
  String testFilesPath = Directory.current.parent.parent.path + '/test/test_files';
  //services.start('${testFilesPath}/input_files', '${testFilesPath}/output_files');
  var req;
  setUp(() async {
    if (new File('${testFilesPath}/output_files/test.mp4').existsSync()) {
      new File('${testFilesPath}/output_files/test.mp4').deleteSync();
    }
    services.start('${testFilesPath}/input_files', '${testFilesPath}/output_files');
    await app.redstoneSetUp();
    req = new app.MockRequest("/fetch");
    await services.outputStore.stream.first;
    await services.inputStore.stream.first;

  });
  tearDown(() async {
    await services.stop();
    await app.redstoneTearDown();
  });

  test("/fetch gets all mkvs", () async {
    //services.start('${testFilesPath}/input_files', '${testFilesPath}/output_files');


    return app.dispatch(req).then( (resp) {
      expect(resp.statusCode, equals(200));
      expect(resp.mockContent, equals(
          """/Users/maxwellclarke/workspaces/nCodr/test/test_files/input_files/folder/test_nested.mkv:/Users/maxwellclarke/workspaces/nCodr/test/test_files/output_files/test_nested.mp4
/Users/maxwellclarke/workspaces/nCodr/test/test_files/input_files/test space.mkv:/Users/maxwellclarke/workspaces/nCodr/test/test_files/output_files/test space.mp4
/Users/maxwellclarke/workspaces/nCodr/test/test_files/input_files/test.mkv:/Users/maxwellclarke/workspaces/nCodr/test/test_files/output_files/test.mp4"""
      ));
    });
  });

  test("/fetch gets only mkvs that exist in input directory but not output directory", () async {
    await new File('${testFilesPath}/output_files/test.mp4').create();
    await services.outputStore.stream.first;

    return app.dispatch(req).then( (resp) {
      expect(resp.statusCode, equals(200));
      expect(resp.mockContent, equals(
      """/Users/maxwellclarke/workspaces/nCodr/test/test_files/input_files/folder/test_nested.mkv:/Users/maxwellclarke/workspaces/nCodr/test/test_files/output_files/test_nested.mp4
/Users/maxwellclarke/workspaces/nCodr/test/test_files/input_files/test space.mkv:/Users/maxwellclarke/workspaces/nCodr/test/test_files/output_files/test space.mp4"""
      ));
    });

  });
}