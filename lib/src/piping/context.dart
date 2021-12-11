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

  T? lookup<T extends Pipe>() =>
      _current is T ? _current as T : _ancestorContext?.lookup();

  T? predecessorOf<T extends Pipe>() {
    for (Pipe pipe in _predecessors.values) if (pipe is T) return pipe;
  }

  T? predecessorWith<T extends Pipe>(Label label) {
    for (MapEntry entry in _predecessors.entries)
      if (entry.key == label && entry.value is T) return entry.value;
  }
}
