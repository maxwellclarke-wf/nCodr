library web_watcher.services;

import 'package:redstone/redstone.dart' as app;
import 'package:web_watcher/watcher.dart';
import 'package:web_watcher/watcher/config.dart';
import 'package:di/di.dart';

import 'dart:io';
import 'package:path/path.dart';

DirectoryStore get inputStore => _inputStore;
DirectoryStore _inputStore;

DirectoryStore get outputStore => _outputStore;
DirectoryStore _outputStore;

Config get inputConfig => _inputConfig;
Config _inputConfig;
Config get outputConfig => _outputConfig;
Config _outputConfig;

@app.Route("/fetch")
fetchList(/*@app.Inject() DirectoryStore store*/) {

  /*if (store != null) {
    print('yay, it exists!');
    return '${store.lastUpdate} : ${store.nodes}';
  }
  else {
    print('store gone, yo');
  }
  return 'no sirree';*/
  // this returns all mkvs without a match in outputStore
  List<FileSystemEntity> returnList = _inputStore.nodes.where((entity) {
    // matching nodes
    if (extension(entity.path) != '.mkv') {
      return false;
    }
  String inName = basenameWithoutExtension(entity.path);
  return !outputStore.nodes.any((outEntity) {
      String outName = basenameWithoutExtension(outEntity.path);
      return outName == inName &&['.mkv', '.mp4', '.m4v'].any((ext) =>
              extension(outEntity.path) == ext);

    });
  }).toList();

  return returnList.map((entity) => "${entity.path}:${outputConfig.checkPath}/${basenameWithoutExtension(entity.path)}.mkv").toList();
}

start(String inPath, String outPath) async {
  Duration refreshPeriod = new Duration(seconds: 15);
  _inputConfig = new Config(inPath, refreshPeriod);
  _outputConfig = new Config(outPath, refreshPeriod);

  _inputStore = new DirectoryStore(_inputConfig);
  _outputStore = new DirectoryStore(_outputConfig);

  app.addModule(new Module()
    //..bind(DirectoryStore, toValue:store)
  );
  app.setupConsoleLog();
  app.start(address: 'localhost');
}