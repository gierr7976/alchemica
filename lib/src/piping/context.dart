part of alchemica.piping;

@immutable
class PipeContext {
  final PipeContext? _ancestorContext;
  final Pipe _current;
  final Map<Label, Pipe> _predecessors;

  const PipeContext._({
    required Pipe current,
    PipeContext? ancestorContext,
    Map<Label, Pipe>? predecessors,
  })  : _ancestorContext = ancestorContext,
        _current = current,
        _predecessors = predecessors ?? const {};

  PipeContext _derivative(Pipe child, {bool dropPredecessors = false}) =>
      PipeContext._(
        current: child,
        ancestorContext: this,
        predecessors: dropPredecessors ? null : _predecessors,
      );

  T? lookup<T extends Pipe>() => // TODO: add unit test
      _current is T ? _current as T : _ancestorContext?.lookup();

  T? predecessorWith<T extends Pipe>([Label? label]) {
    for (MapEntry entry in _predecessors.entries)
      if (entry.key == (label ?? entry.key) && entry.value is T)
        return entry.value;
  }
}
