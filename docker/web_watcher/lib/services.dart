library web_watcher.services;

import 'package:redstone/redstone.dart' as app;

@app.Route("/fetch")
fetchList() => 'a list';

start() {
  app.setupConsoleLog();
  app.start(address: 'localhost');
}