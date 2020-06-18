import 'dart:convert';
import 'dart:io';
import 'package:arb_tsv/bundle.dart';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser();
  final result = parser.parse(['bin']);
  final filePath = result.command.rest.firstWhere(
    (argument) =>
        argument.startsWith(RegExp(r'.{0,1}/')) ||
        argument.startsWith(RegExp(r'^\w*$')) ||
        argument.startsWith(RegExp(r'\D:/')),
    orElse: () => '.',
  );

  if (!Directory(filePath).existsSync()) {
    print('Cannot find path specified. $filePath');
    print('Usage: arb2tsv [intl_messages.arb file path]');
    exit(0);
  }

  _parseArb(File('$filePath/intl_messages.arb'));
}

void _parseArb(File arb) {
  if (!arb.existsSync()) {
    print('Cannot find intl_messages.arb at ${arb.path}.');
    print('Usage: arb2tsv [intl_messages.arb file path]');
    exit(0);
  }

  final arbJson = json.decode(arb.readAsStringSync()) as Map<String, dynamic>;

  final bundle = Bundle.fromArb(arbJson);

  print(bundle.arb);
}
