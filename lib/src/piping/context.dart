part of alchemica.piping;

class PipeContext {
  final Pipe _current;
  final PipeContext? _inherited;

  const PipeContext({
    required Pipe current,
    PipeContext? inherited,
  })  : _current = current,
        _inherited = inherited;

  PipeContext inherit(Pipe inheritor) => PipeContext(
        current: inheritor,
        inherited: this,
      );

  P? lookup<P extends Pipe>([Label? label]) {
    final P? maybeCurrent = _current._conditional(label);

    return maybeCurrent ?? _inherited?.lookup(label);
  }

  void require<P extends Pipe>([Label? label]) {
    final P? required = lookup(label);

    if (required == null) throw StateError("Unsatisfied requirement!");
  }
}
