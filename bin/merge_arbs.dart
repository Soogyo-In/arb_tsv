import 'dart:convert';
import 'dart:io';

import 'package:arb_tsv/bundle.dart';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser();
  final result = parser.parse(arguments);
  final sourceArbFile = File(result.rest.first);
  final targetDirectories =
      result.rest.skip(1).map<Directory>((path) => Directory(path));
  final targetArbFiles = <File>{};

  if (!sourceArbFile.path.contains('.arb')) {
    print(
        'Just one source arb file must specified. The [${sourceArbFile.path}] is not a arb file.');
    print(
        'Usage: merge_arbs [source arb file path] [merge target arb file paths]');
    exit(0);
  }

  if (!sourceArbFile.existsSync()) {
    print('Cannot find path specified which [${sourceArbFile.path}].');
    print(
        'Usage: merge_arbs [source arb file path] [merge target arb file paths]');
    exit(0);
  }

  for (final target in targetDirectories) {
    if (target.path.contains('.arb')) {
      if (!File(target.path).existsSync()) {
        print('Cannot find arb file specified which [${target.path}].');
        print(
            'Usage: merge_arbs [source arb file path] [merge target arb file paths]');
        exit(0);
      }
    } else if (!target.existsSync()) {
      print('Cannot find path specified which [${target.path}].');
      print(
          'Usage: merge_arbs [source arb file path] [merge target arb file paths]');
      exit(0);
    }
  }

  for (final target in targetDirectories) {
    if (target.path.contains('.arb')) {
      targetArbFiles.add(File(target.path));
    } else {
      targetArbFiles.addAll(
        target
            .listSync()
            .where((directory) => directory.path.contains('.arb'))
            .map((directory) => File(directory.path)),
      );
    }
  }
  targetArbFiles.removeWhere((arbFile) => arbFile.uri == sourceArbFile.uri);

  final sourceArb = Bundle.fromFile(sourceArbFile);

  for (final arbFile in targetArbFiles) {
    final bundle = Bundle.fromFile(arbFile);
    final mergedBundle = bundle.merge(sourceArb);
    arbFile.writeAsStringSync(json.encode(mergedBundle.arb));
  }
}
