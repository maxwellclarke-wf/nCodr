library tool.dev;

import 'package:dart_dev/dart_dev.dart' show dev, config;

main(List<String> args) async {
  // https://github.com/Workiva/dart_dev

  // Perform task configuration here as necessary.

  // Available task configurations:
  config.analyze
    ..fatalWarnings = true
    ..strong = true;
  // config.copyLicense
  // config.coverage
  // config.docs
  // config.examples
  // config.format
  config.test
    ..unitTests = ['test/services_test.dart']
    ..platforms = ['vm'];

  await dev(args);
}
