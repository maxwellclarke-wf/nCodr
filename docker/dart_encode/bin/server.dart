/**
 * nCoder
 *
 * Gets all the mkvs for a folder and transcodes them.
 */

import 'dart:io';
import 'dart:async';

void runTest() {
  runCheck(new Config(
      'ffmpeg',
      ['-vcodec copy -acodec copy'],
  "/Users/maxwellclarke/workspaces/platform/nCoder/test/test_files/input_files",
  "/Users/maxwellclarke/workspaces/platform/nCoder/test/test_files/output_files"
  ));
}

void runProd() {
  runCheck(new Config(
      'ffmpeg',
      ['-vcodec copy -acodec copy'],
  '/encodeIn',
  '/encodeOut'
  ));
}

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

main() async {

  print('starting up like a mofo');
  // get params
  runProd();
}



runCheck(Config config) async {

  writeFile(StringBuffer out) {
    File outputFile = new File('${config.finishFolder}/encodr.sh');
    String  outputString = out.toString();
    int firstBreak = outputString.indexOf('\n');
    if (firstBreak == -1) {
      firstBreak = outputString.length;
    }
    outputFile.writeAsString(outputString.substring(0, firstBreak));

    print('writing file...');
    print(outputString.substring(0, firstBreak));
  }

  print('running check');
  List<File> files = await getMkvFiles(getFiles(config.folderToCheck)).toList();

  if (files.isEmpty) {
    print("No files found, sleeping...");
    writeFile(new StringBuffer());
    new Future.delayed(new Duration(seconds: 30)).then((_) => runCheck(config));
    return;
  }
  Iterator<File> iterator = files.iterator;
  iterator.moveNext();
  StringBuffer out;
  Future chainSyncRunCommand() async {
    out = new StringBuffer();
    File file = iterator.current;
    config.setInputFile(file.path);
    config.setOutputFile(getFileNameWithPath(
        config.finishFolder, file, '.mp4'));

    // Chain waits on process queue
    print('processing file...');
    // process this file
    print('checking if file ${config.outputFile} exists...');
    if (new File(config.outputFile).existsSync()) {
      print('skipping: destination file already exists for ${config.outputFile}');
      if (iterator.moveNext()) {
        return await chainSyncRunCommand();
      }
    } else {
      out.write('${config.pathtoFfmpeg} ${config.getArgs().join(" ")}');
      writeFile(out);
    }

  }
  await chainSyncRunCommand();

  // wait period
  print('all files processed ; waiting 30 seconds....');
  new Future.delayed(new Duration(seconds: 30)).then((_) => runCheck(config));
}

String modifyExtension(String initialPath) {
  return initialPath.replaceAll(new RegExp(r'.mkv$'), '.mp4');
}

Stream<FileSystemEntity> getFiles(String folderToCheck) {
  Directory folder = new Directory(folderToCheck);

  Stream listStream = folder.list(recursive: true);
  return listStream;
}

Stream<FileSystemEntity> getMkvFiles(Stream<FileSystemEntity> files) {
  return files.where((FileSystemEntity file) {
    //print('file: ${file.path}');
    if (file.path.endsWith('.mkv')) {
      print('MKV: ${file.path}');
      return true;
    }
    return false;
  });
}

getFileNameWithPath(String basePath, File fileWithName, String extension) {
  return basePath.replaceAll(new RegExp(r'/^\/+$'), '') + fileWithName.path.replaceAll(fileWithName.parent.path, '').replaceAll('.mkv', extension);
}