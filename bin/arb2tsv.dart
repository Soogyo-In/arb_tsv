import 'dart:io';

import 'package:arb_tsv/bundle.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

const _kDefaultInputDir = '.';
const _kDefaultOutputDir = '.';

void main(List<String> arguments) {
  var outputDir = Directory.current;
  final parser = ArgParser();
  parser.addOption(
    'output-dir',
    abbr: 'o',
    defaultsTo: _kDefaultOutputDir,
    help:
        'Set output directory for generated tsv file. Create directory if given directory is not exists',
    valueHelp: 'output directory',
    callback: (arg) {
      outputDir = Directory(arg?.trim() ?? _kDefaultOutputDir);
      if (!outputDir.existsSync()) outputDir.createSync(recursive: true);
    },
  );

  final result = parser.parse(arguments);
  final targetDirectory =
      Directory(result.rest.isEmpty ? _kDefaultInputDir : result.rest.first);

  if (!targetDirectory.existsSync() && !targetDirectory.path.contains('.arb')) {
    print('Cannot find path specified which [$targetDirectory].');
    print(
        'Usage: arb2tsv [path of arb file or directory containing arb files] [options]');
    print(parser.usage);
    exit(0);
  }

  final arbFiles = <File>{};

  if (targetDirectory.path.contains('.arb')) {
    arbFiles.add(File(targetDirectory.path));
  } else {
    arbFiles.addAll(
      targetDirectory
          .listSync()
          .where((directory) => directory.path.contains('.arb'))
          .map((directory) => File(directory.path)),
    );
  }

  for (final arbFile in arbFiles) {
    final bundle = Bundle.fromFile(arbFile);
    final fileName = path.split(arbFile.path).last.split('.').first;
    final tsvFile = File(path.join(outputDir.path, '$fileName.tsv'));
    tsvFile.writeAsStringSync(bundle.tsv);
  }
}
