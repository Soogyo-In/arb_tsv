class BundleItem {
  final String name;
  final String value;
  final BundleItemOptions options;

  BundleItem(
    this.name,
    this.value, {
    String type = '',
    String description = '',
    Map<String, dynamic> placeholders = const {},
  }) : options = BundleItemOptions(
          type: type,
          description: description,
          placeholders: placeholders,
        );

  Map<String, dynamic> get arb => {
        name: value,
        '@$name': options.arb,
      };

  String get tsv => '$name\t${value.replaceAll('\n', r'\n')}\t${options.tsv}';
}

class BundleItemOptions {
  final String type;
  final String description;
  final Map<String, dynamic> placeholders;

  BundleItemOptions({
    this.type = '',
    this.description = '',
    this.placeholders = const {},
  });

  Map<String, dynamic> get arb => {
        'type': type,
        'desc': description,
        'placeholders': placeholders,
      };

  String get tsv =>
      '${description.replaceAll('\n', r'\n')}\t${placeholders.keys}\t$type';
}
