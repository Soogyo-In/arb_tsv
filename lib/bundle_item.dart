class BundleItem {
  final String name;
  final String value;
  final BundleItemOptions options;

  BundleItem(
    this.name,
    this.value, {
    String type,
    String description,
    Map<String, dynamic> placeholders = const {},
  }) : options = BundleItemOptions(
          type: type,
          description: description,
          placeholders: placeholders,
        );

  Map<String, String> get arb => {
        name: value,
        '@$name': options.arb.toString(),
      };
}

class BundleItemOptions {
  final String type;
  final String description;
  final Map<String, dynamic> placeholders;

  BundleItemOptions({
    this.type,
    this.description,
    this.placeholders = const {},
  });

  Map<String, String> get arb {
    final _arb = <String, String>{};

    if (type != null) _arb.putIfAbsent('type', () => type);
    if (description != null) _arb.putIfAbsent('desc', () => description);
    if (placeholders != null) {
      _arb.putIfAbsent('placeholders', () => placeholders.toString());
    }

    return _arb;
  }
}
