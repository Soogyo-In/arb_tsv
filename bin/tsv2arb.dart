import 'dart:io';
import 'dart:convert';
import 'package:arb_tsv/bundle.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

void main(List<String> arguments) {
  var outputDir = Directory.current.path;
  final parser = ArgParser();
  parser.addOption(
    'output-dir',
    abbr: 'o',
    defaultsTo: '.',
    help: 'Set output directory for generated tsv file.',
    valueHelp: 'output directory',
    callback: (path) {
      if (!Directory(path).existsSync()) {
        print('Cannot find path specified which ${path}');
        print('Usage: tsv2arb [tsv file path] [options]');
        print(parser.usage);
        exit(0);
      }

      outputDir = path;
    },
  );

  final result = parser.parse(arguments);
  final targetDirectory = Directory(result.rest.firstWhere(
    (argument) =>
        argument.startsWith(RegExp(r'.{0,1}')) ||
        argument.startsWith(RegExp(r'^\w*$')) ||
        argument.startsWith(RegExp(r'\D:/')),
    orElse: () => '.',
  ));

  if (!targetDirectory.existsSync() && !targetDirectory.path.contains('.tsv')) {
    print('Cannot find path specified which $targetDirectory');
    print('Usage: tsv2arb [tsv file path] [options]');
    print(parser.usage);
    exit(0);
  }

  final tsvFiles = <File>[];

  if (targetDirectory.path.contains('.tsv')) {
    tsvFiles.add(File(targetDirectory.path));
  } else {
    tsvFiles.addAll(
      targetDirectory
          .listSync()
          .where((directory) => directory.path.contains('.tsv'))
          .map((directory) => File(directory.path)),
    );
  }

  for (final tsvFile in tsvFiles) {
    final bundle = Bundle.fromTsv(tsvFile.readAsStringSync());
    final fileName = tsvFile.path.split(r'\').last.split('.').first;
    final arbFile = File(path.join(outputDir, '${fileName}.arb'));
    arbFile.writeAsStringSync(json.encode(bundle.arb));
  }
}
