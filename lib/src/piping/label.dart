part of alchemica.piping;

@immutable

/// Label for matching [Pipe]s.
///
/// Used in tree mutations.
class Label<T> {
  /// Matched value itself.
  final T _value;

  /// Default constructor for external clients.
  ///
  /// Expected to use with data matching values.
  const Label(this._value);

  /// Default internal constructor.
  ///
  /// As some [Pipe] instances intended to be preservable after tree mutation,
  /// by default it is matched by type.
  ///
  /// <br>
  /// _Check also: [Flask], [Root]._
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
