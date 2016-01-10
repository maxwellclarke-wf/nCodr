library web_watcher;

// redstone import must be first in order to register services
import 'package:redstone/redstone.dart' as app;
import 'packages/web_watcher/services.dart' as services;



main() {
  services.start();
}