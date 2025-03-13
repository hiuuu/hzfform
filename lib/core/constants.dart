class HZFFormConstants {
  static const emailRegEx =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
}

extension ObjectExtension on Object? {
  bool get isNullOrEmpty => this == null || this == '';

  bool get isNullEmptyOrFalse =>
      this == null || this == '' || (this is bool && this != true);

  bool get isNullEmptyZeroOrFalse =>
      this == null ||
      this == '' ||
      (this is bool && this != true) ||
      (this is num && this == 0);
}

extension NullableLet<T> on T? {
  void apply(void Function(T) action) {
    if (this != null) {
      action(this as T);
    }
  }
}

extension ListExtension<T> on List<T> {
  void addIfNotNull(T? value) => value != null ? add(value) : null;
}

extension MapExtension<K, V> on Map<K, V> {
  void addIfNotNull(K? key, V? value) =>
      key != null && value != null ? this[key] = value : null;
}

extension StringExtension on String {
  String capitalize() => isNotEmpty
      ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
      : this;
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.capitalize())
      .join(' ');
}
