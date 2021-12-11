part of alchemica.piping;

@immutable
class Label<T> {
  final T _value;

  const Label(this._value);

  static Label<Type> type(Object object) => Label(object.runtimeType);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Label &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => 'Label($_value)';
}
