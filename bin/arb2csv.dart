import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser();
  final arb2csvCommand = ArgParser();

  // for (final directory in Directory(arguments[0]).listSync()) {
  //   directory.path.contains(RegExp(r'.arb$'));
  // }

  parser.addCommand('arb2csv', arb2csvCommand);

  final result = parser.parse(['arb2csv', 'bin']);

  switch (result.command.name ?? '') {
    case 'arb2csv':
      final filePath = result.command.rest.firstWhere(
        (argument) =>
            argument.startsWith(RegExp(r'.{0,1}/')) ||
            argument.startsWith(RegExp(r'^\w*$')) ||
            argument.startsWith(RegExp(r'\D:/')),
        orElse: () => '.',
      );
      if (!Directory(filePath).existsSync()) {
        throw FileSystemException('Cannot find path specified.');
      }
      
      _parseArb(File('$filePath/intl_messages.arb'));
      break;
    default:
      throw UnsupportedError(result.command.name);
  }
}

void _parseArb(File arb) {
  if (!arb.existsSync()) {
    throw FileSystemException(
      'Cannot find intl_messages.arb at ${arb.path}.',
    );
  }
  final arbJson = json.decode(arb.readAsStringSync());
  print(arbJson);
}
