part of alchemica.piping;

class PipeContext {
  final Pipe _current;
  final PipeContext? _inherited;
  final Map<Label, Potion>? _preserved;
  final BypassDispatcher bypassDispatcher;

  const PipeContext({
    required Pipe current,
    required this.bypassDispatcher,
    PipeContext? inherited,
    Map<Label, Potion>? preserved,
  })  : _current = current,
        _inherited = inherited,
        _preserved = preserved;

  PipeContext inherit(Pipe inheritor) => PipeContext(
        current: inheritor,
        bypassDispatcher: bypassDispatcher,
        inherited: this,
        preserved: _preserved,
      );

  //<editor-fold desc="Search methods">

  P? lookup<P extends Pipe>([Label? label]) {
    final P? maybeCurrent = _current._conditional(label);

    return maybeCurrent ?? _inherited?.lookup(label);
  }

  //</editor-fold>

  //<editor-fold desc="Preservation methods">

  P? getPreserved<P extends Potion>([Label? label]) {
    if (_preserved is Map) {
      if (label is Label) return _preservedByLabel(label);

      return _preservedByType();
    }

    return null;
  }

  P? _preservedByLabel<P extends Potion>(Label label) {
    final Potion? suggested = _preserved![label];

    return suggested is P ? suggested : null;
  }

  P? _preservedByType<P extends Potion>() {
    for (Potion potion in _preserved!.values) if (potion is P) return potion;

    return null;
  }

  //</editor-fold>

  //<editor-fold desc="Checks">

  void require<P extends Pipe>([Label? label]) {
    final P? required = lookup(label);

    if (required == null) throw StateError("Unsatisfied requirement!");
  }

//</editor-fold>
}
