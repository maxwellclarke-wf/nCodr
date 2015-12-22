/**
 * nCoder
 *
 * Gets all the mkvs for a folder and transcodes them.
 */

import 'dart:io';
import 'dart:async';

class Config {
  String get inPath => _inPath;
  String _inPath;
  String get outPath => _outPath;
  String _outPath;

  Duration get repeatDelay => _repeatDelay;
  Duration _repeatDelay;

  Config(String inPath, String outPath, Duration repeatDelay) : _inPath=inPath, _outPath=outPath, _repeatDelay=repeatDelay;
}

void main() {
  Config config = new Config(
      '/encodeIn',
      '/encodeOut',
      new Duration(seconds: 30)
  );

  new Runner(() async {
    print('running');
    Source src = new FilteredSource(
        new Directory(config.inPath),
        (FileSystemEntity entity) {
      String filePath = getFileNameWithPath(config.outPath, entity, '.mp4');
      bool dstExists = new File(filePath).existsSync();
      bool isFile = entity.statSync().type == FileSystemEntityType.FILE && entity.path.endsWith('.mkv');

      return isFile && !dstExists;
    });
    Output output = new Output(src.files, config.outPath, (FileSystemEntity entity) {
      return "${entity.path}:${getFileNameWithPath(config.outPath, entity, '.mp4')}";
    });

    await output.process();

  }, delay: new Duration(seconds:15));
}


class Runner {
  Function get runFn => _runFn;
  Function _runFn;
  Duration get delay => _delay;
  Duration _delay;
  RunnerStatus get status => _status;
  RunnerStatus _status;

  Runner(this._runFn, {delay: Duration.ZERO, status: RunnerStatus.Initializing}) {
    _delay = delay;
    _status = status;
    _run();
  }

  _run() async {
    Stopwatch watch = new Stopwatch();
    watch.start();
    _status = RunnerStatus.Running;
    print('running');
    await _runFn();
    watch.stop();
    print('done in ${watch.elapsed}');
    _status = RunnerStatus.Delayed;
    new Future.delayed(delay).whenComplete(_run);
  }
}

enum RunnerStatus {
  Initializing,
  Running,
  Delayed
}

class Source {
  Directory get dir => _dir;
  Directory _dir;
  Stream<FileSystemEntity> get files => _dir.list(recursive: true);

  Source(this._dir);
}

class FilteredSource extends Source {
  Stream<FileSystemEntity> get files => dir.list(recursive: true).where(_filter);
  Function _filter;

  FilteredSource(Directory dir, bool filter(FileSystemEntity)) : super(dir) {
    _filter = filter;
  }
}

class Output {
  Stream<String> get out => _in.map(_processFn);
  Stream<FileSystemEntity> _in;
  Function _processFn;
  String _outPath;

  Output(this._in, this._outPath, this._processFn(FileSystemEntity));

  Future process() async {
    List<String> allOutput = await out.toList();
    print('got all output: ${allOutput.length} items: ${allOutput}');
    new File('${_outPath}/.encodr')..createSync()..writeAsStringSync(allOutput.join("\n"), flush: true);
  }
}
getFileNameWithPath(String basePath, File fileWithName, String extension) {
  return basePath.replaceAll(new RegExp(r'/^\/+$'), '') + fileWithName.path.replaceAll(fileWithName.parent.path, '').replaceAll('.mkv', extension);
}