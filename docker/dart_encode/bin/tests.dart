import 'package:guinness/guinness.dart';
import 'package:test/test.dart';
import 'server.dart';

import 'dart:io';

// PLAN: Finish up first version and come back and try the same thing using TDD

main() async {
  Config testConfig = new Config(
      'ffmpeg',
      ['-vcodec copy -acodec copy'],
      "/Users/maxwellclarke/workspaces/platform/nCoder/test/test_files/input_files",
      "/Users/maxwellclarke/workspaces/platform/nCoder/test/test_files/output_files"
  );
  describe('nCoder', () {
    group('filesystem', () {
      it('returns all files in a directory', () {
        getFiles(testConfig.inPath).listen((FileSystemEntity entity) {
          print(entity.toString());
        });
      });
      it('returns all files with a certain extension', () {

      });
      it('returns file name', () {

      });
    });
    group('encode service', () {
      it('adds an encode request to the queue', () {

      });
      it('removes a finished encode from the queue', () {

      });
      it('', () {

      });
    });
  });
}

/*
group('', ()
{
  it('', () {

  });
  it('', () {

  });
});*/
