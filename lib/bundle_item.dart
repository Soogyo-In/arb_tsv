class BundleItem {
  final String name;
  final String value;
  final BundleItemOptions options;

  BundleItem(
    this.name,
    this.value, {
    String type,
    String description,
    Set<String> placeholders = const {},
  }) : options = BundleItemOptions(
          type: type,
          description: description,
          placeHolders: placeholders,
        );
}

class BundleItemOptions {
  final String type;
  final String description;
  final Set<String> placeHolders;

  BundleItemOptions({
    this.type,
    this.description,
    this.placeHolders = const {},
  });
}
