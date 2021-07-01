/// Model class for item in ARB file.
class BundleItem {
  final String name;
  final String value;
  final BundleItemOptions options;

  BundleItem({
    required this.name,
    required this.value,
    String type = '',
    String description = '',
    Map<String, dynamic> placeholders = const {},
  }) : options = BundleItemOptions(
          type: type,
          description: description,
          placeholders: placeholders,
        );

  /// Get ARB format Object.
  Map<String, dynamic> get arb => {
        name: value,
        '@$name': options.arb,
      };

  /// Get TSV string.
  String get tsv =>
      '${name.replaceAll('\n', r'\n')}\t${value.replaceAll('\n', r'\n')}\t${options.tsv}';
}

/// Model class for options in ARB item.
class BundleItemOptions {
  final String type;
  final String description;
  final Map<String, dynamic> placeholders;

  BundleItemOptions({
    this.type = '',
    this.description = '',
    this.placeholders = const {},
  });

  /// Get ARB format Object.
  Map<String, dynamic> get arb => {
        'type': type,
        'desc': description,
        'placeholders': placeholders,
      };

  /// Get TSV string.
  String get tsv =>
      '${description.replaceAll('\n', r'\n')}\t${placeholders.keys}\t$type';
}
