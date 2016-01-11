library web_watcher.lib.watcher;

export 'package:web_watcher/services.dart' show start;
import 'package:web_watcher/watcher/config.dart';

import 'dart:async';
import 'dart:io';

class DirectoryStore {
  StreamController _streamController;
  Stream get stream => _streamController.stream;
  Config _config;
  //Runner _runner;
  List<FileSystemEntity> _nodes = [];
  List<FileSystemEntity> get nodes => _nodes;
  int get lastUpdate => _lastUpdate;
  int _lastUpdate = 0;

  DirectoryStore(Config config) {
    _config = config;
    new Runner(_fetchNodes, delay: _config.repeatDelay);
    _streamController = new StreamController.broadcast();
  }

  void listen(Function callback) {
    stream.listen((_) => callback());
  }

  _fetchNodes() async {
    print('fetching nodes...');
    List<FileSystemEntity> newNodes = await new Directory(_config.checkPath).list(recursive: true).toList();
    _nodes = newNodes;
    _lastUpdate++;
    _trigger();
  }

  void _trigger() {
    _streamController.add(_lastUpdate);
  }
}

