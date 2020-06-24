import 'dart:convert';
import 'dart:io';
import 'package:arb_tsv/bundle.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

ArgParser _parser;
void main(List<String> arguments) {
  var outputDir = Directory.current.path;

  _parser = ArgParser()
    ..addOption(
      'output-dir',
      abbr: 'o',
      defaultsTo: '.',
      help: 'Set output directory for generated tsv file.',
      valueHelp: 'output directory',
      callback: (path) {
        if (!Directory(path).existsSync()) {
          print('Cannot find path specified which ${path}');
          print('Usage: arb2tsv [arb file path] [options]');
          print(_parser.usage);
          exit(0);
        }

        outputDir = path;
      },
    );
  final result = _parser.parse(['C:/']);
  // final result = parser.parse(arguments);
  
  final filePath = result.rest.firstWhere(
    (argument) =>
        argument.startsWith(RegExp(r'.{0,1}')) ||
        argument.startsWith(RegExp(r'^\w*$')) ||
        argument.startsWith(RegExp(r'\D:/')),
    orElse: () => '.',
  );

  if (!Directory(filePath).existsSync()) {
    print('Cannot find path specified which $filePath');
    print('Usage: arb2tsv [arb file path] [options]');
    print(_parser.usage);
    exit(0);
  }

  final bundle = _parseArb(File(path.join(filePath, 'intl_messages.arb')));

  outputDir = path.join(outputDir, 'test.tsv');

  final tsv = File(outputDir);

  tsv.writeAsStringSync(bundle.tsv);
}

Bundle _parseArb(File arb) {
  if (!arb.existsSync()) {
    print('Cannot find arb file from ${arb.parent.path}');
    print('Usage: arb2tsv [arb file path] [options]');
    print(_parser.usage);
    exit(0);
  }

  final Map<String, dynamic> arbJson = json.decode(arb.readAsStringSync());

  return Bundle.fromArb(arbJson);
}
