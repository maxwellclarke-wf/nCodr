import 'package:redstone/redstone.dart' as app;
import 'package:test/test.dart';
import 'package:web_watcher/services.dart' as services;

main() {
  services.start();

  setUp(app.redstoneSetUp);
  tearDown(app.redstoneTearDown);

  test("/fetch", () {
    var req = new app.MockRequest("/fetch");
    return app.dispatch(req).then((resp) {
      expect(resp.statusCode, equals(200));
      print(resp.mockContent);
      expect(resp.mockContent, equals("a list"));
    });
  });
}