/**
 * nCoder
 *
 * Gets all the mkvs for a folder and transcodes them.
 */
library nCodr;

import 'dart:io';
import 'dart:async';
import 'package:nCodr/nCodr.dart';

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