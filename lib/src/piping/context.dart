part of alchemica.piping;

/// Surrounding of [Pipe] in logic tree.
///
/// Provides access to upstream [Pipe]s and predecessors.
@immutable
class PipeContext {
  /// Context of ancestor.
  ///
  /// Should be provided if current element is child of other element.
  final PipeContext? _ancestorContext;

  /// Current logic tree element itself.
  final Pipe _current;

  /// All items preserved after latest tree mutation.
  ///
  /// Intended be provided at once immediately after tree mutation.
  final Map<Label, Pipe> _predecessors;

  /// Internal constructor.
  const PipeContext._({
    required Pipe current,
    PipeContext? ancestorContext,
    Map<Label, Pipe>? predecessors,
  })  : _ancestorContext = ancestorContext,
        _current = current,
        _predecessors = predecessors ?? const {};

  /// Creates derivative context to drip child.
  PipeContext _derivative(Pipe child, {bool dropPredecessors = false}) =>
      PipeContext._(
        current: child,
        ancestorContext: this,
        predecessors: dropPredecessors ? null : _predecessors,
      );

  // TODO: add unit test
  T? lookup<T extends Pipe>([Label? label]) {
    final Label exactLabel = label ?? _current.label;

    if(_current is T && _current.label == exactLabel) return _current as T;

    return _ancestorContext?.lookup(label);
  }

  T? predecessorWith<T extends Pipe>([Label? label]) {
    for (MapEntry entry in _predecessors.entries)
      if (entry.key == (label ?? entry.key) && entry.value is T)
        return entry.value;
  }
}
