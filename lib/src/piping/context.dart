part of alchemica.piping;

/// Context of logic tree element.
///
/// <br>
/// Provides information about the ancestor elements,
/// [BypassDispatcher] and [FuseDispatcher] to be used by the element,
/// as well as the [Potion]s saved when the logic tree was last rebuilt.
class PipeContext {

  /// [Pipe] for which this context is provided.
  final Pipe _current;

  /// [PipeContext] for ancestor element.
  final PipeContext? _inherited;

  /// Collection of potions saved when the logic tree was last rebuilt.
  ///
  /// <br>
  /// Check [Pipe.collect] for reference.
  final Map<Label, Potion>? _preserved;

  /// [BypassDispatcher] to be used by element.
  final BypassDispatcher bypassDispatcher;

  /// [FuseDispatcher] to be used by element.
  final FuseDispatcher fuseDispatcher;

  /// Default constructor.
  const PipeContext({
    required Pipe current,
    required this.bypassDispatcher,
    required this.fuseDispatcher,
    PipeContext? inherited,
    Map<Label, Potion>? preserved,
  })  : _current = current,
        _inherited = inherited,
        _preserved = preserved;

  /// Creates [PipeContext] for child of element
  /// for which this context is provided.
  PipeContext inherit(Pipe inheritor) => PipeContext(
        current: inheritor,
        bypassDispatcher: bypassDispatcher,
        fuseDispatcher: fuseDispatcher,
        inherited: this,
        preserved: _preserved,
      );

  //<editor-fold desc="Search methods">

  /// Performs a upward search for logic tree element that matches given
  /// condition.
  ///
  /// <br>
  /// Returns first found ancestor element that is an instance of [P]
  /// and has label equal to [label]. Skips element for which this context
  /// is provided if [skipCurrent] is [true].
  ///
  /// <br>
  /// Not intended to be used outside of Alchemica.
  P? lookup<P extends Pipe>([Label? label, bool skipCurrent = false]) {
    final P? maybeCurrent = skipCurrent ? null : _current._conditional(label);

    return maybeCurrent ?? _inherited?.lookup(label);
  }

  //</editor-fold>

  //<editor-fold desc="Preservation methods">

  /// Searches for [Potion] matching given condition within
  /// preserved when the logic tree was last rebuilt.
  ///
  /// <br>
  /// Return first found preserved [Potion] from [Pipe] with label equal to [label]
  /// if [label] is given. Always returns first found preserved [Potion] that is
  /// an instance of [P] or [null] if there isn't any preserved [Potion]
  /// matching all given conditions.
  P? getPreserved<P extends Potion>([Label? label]) {
    if (_preserved is Map) {
      if (label is Label) return _preservedByLabel(label);

      return _preservedByType();
    }

    return null;
  }

  /// Searches for preserved [Potion] that is an instance of [P] and has label
  /// equal to [label].
  ///
  /// Returns first found [Potion] matching given condition
  /// or [null] if not found.
  P? _preservedByLabel<P extends Potion>(Label label) {
    final Potion? suggested = _preserved![label];

    return suggested is P ? suggested : null;
  }

  /// Searches for preserved [Potion] that is an instance of [P].
  ///
  /// Returns first found [Potion] matching given condition
  /// or [null] if not found.
  P? _preservedByType<P extends Potion>() {
    for (Potion potion in _preserved!.values) if (potion is P) return potion;

    return null;
  }

  //</editor-fold>

  //<editor-fold desc="Checks">


  /// Requires [Pipe] matching given conditions to be presented as ancestor
  /// element.
  ///
  /// Returns first found ancestor element that is an instance of [P] and has
  /// label equal to [label] or throws a [StateError] if not found.
  P require<P extends Pipe>([Label? label]) {
    final P? required = lookup(label);

    if (required == null) throw StateError("Unsatisfied requirement!");
    return required;
  }

//</editor-fold>
}
