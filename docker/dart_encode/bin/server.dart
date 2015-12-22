/**
 * nCoder
 *
 * Gets all the mkvs for a folder and transcodes them.
 */

import 'dart:io';
import 'dart:async';

class Config {
  String pathtoFfmpeg;
  List<String> ffmpegArgs;
  String folderToCheck;
  String finishFolder;

  Config(this.pathtoFfmpeg, this.ffmpegArgs, this.folderToCheck, this.finishFolder);

  String inputFile;
  String outputFile;

  setInputFile(String inputFile) => this.inputFile = inputFile;
  setOutputFile(String outputFile) => this.outputFile = outputFile;

  getArgs() {
    return [
      '-n',
      '-i',
      '\'${inputFile}\'',
      '-vcodec',
      'copy',
      '-acodec',
      'copy',
      '\'${outputFile}\''
    ];
  }
}

Config config = new Config(
    'ffmpeg',
    ['-vcodec copy -acodec copy'],
    '/encodeIn',
    '/encodeOut'
);

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
    _status = RunnerStatus.Running;
    print('running');
    await _runFn();
    print('done, waiting...');
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
  Function _processFn;

  Stream<FileSystemEntity> _in;

  Output(this._in, String this._processFn(FileSystemEntity) );

  Future process() async {
    List<String> allOutput = await out.toList();
    print('got all output: ${allOutput.length} items: ${allOutput}');
    new File('${config.finishFolder}/.encodr')..createSync()..writeAsStringSync(allOutput.join("\n"), flush: true);
  }
}

void main() {
  new Runner(() async {
    print('running');
    Source src = new FilteredSource(
        new Directory(config.folderToCheck),
        (FileSystemEntity entity) {
          //print('checking file ${entity.path}');
          String filePath = getFileNameWithPath(config.finishFolder, entity, '.mp4');
          bool dstExists = new File(filePath).existsSync();
          //print('filePath: ${filePath}, exists: ${dstExists}');
          return entity.statSync().type == FileSystemEntityType.FILE && entity.path.endsWith('.mkv') && !dstExists;
    }
    );
    print('creating output...');
    Output output = new Output(src.files, (FileSystemEntity entity) {
      return "${entity.path}:${getFileNameWithPath(config.finishFolder, entity, '.mp4')}";
    });

    print('running output.process()');
    await output.process();

  }, delay: new Duration(seconds:15));
}

getFileNameWithPath(String basePath, File fileWithName, String extension) {
  return basePath.replaceAll(new RegExp(r'/^\/+$'), '') + fileWithName.path.replaceAll(fileWithName.parent.path, '').replaceAll('.mkv', extension);
}