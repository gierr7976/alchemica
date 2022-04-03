part of alchemica.labeling;

class Label<T> {
  final T value;

  Label(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Label &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}

mixin Labelable {
  Label get label => Label(runtimeType);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Labelable && label == other.label;

  @override
  int get hashCode => label.hashCode;
}
