part of alchemica.piping;

/// Basic logic tree element.
///
/// <br>
/// Provides lifecycle interface and simple features such as labeled matching,
/// label – potion pairs preservation and downward search.
abstract class Pipe with Labelable {
  /// Potion stored in this element.
  Potion? get potion => null;

  //<editor-fold desc="Lifecycle methods">

  /// Installs this element and its children elements (if any presented) onto
  /// logic tree.
  ///
  /// <br>
  /// [context] — [PipeContext] of this element.
  ///
  /// <br>
  /// Should also call [install] on children elements with inherited context.
  /// Check [PipeContext.inherit] for reference.
  void install(PipeContext context);

  /// Processes given [ingredient].
  ///
  /// <br>
  /// Should also call [pass] on children if any presented.
  void pass(Ingredient ingredient);

  /// Uninstalls this element and its children from logic tree.
  ///
  /// <br>
  /// Should also call [uninstall] on children elements if any presented.
  void uninstall();

  //</editor-fold>

  //<editor-fold desc="Extraction methods">

  /// Checks if this element matching given condition.
  ///
  /// Returns this element if matching, otherwise returns [null].
  ///
  /// <br>
  /// [P] — preferred type. This element matches condition only if it is
  ///       an instance of [P].
  ///
  /// [label] — preferred [Label]. This element matches condition only if its
  ///           label is equal to [Label].
  P? _conditional<P extends Pipe>([Label? label]) {
    if (this is P) {
      final Label suggested = label ?? this.label;

      if (this.label == suggested) return this as P;
    }

    return null;
  }

  /// Performs a downward search in logic tree.
  ///
  /// Returns first element that is an instance of [P] and has label
  /// equal to [label].
  @mustCallSuper
  P? find<P extends Pipe>([Label? label]) => _conditional(label);

  /// Collects potions from this element and its children.
  ///
  /// Returns a [Map] with collection of [Potion]s extracted from this element
  /// and its children. The [Label] of the source element
  /// is represented as a key.
  @mustCallSuper
  Map<Label, Potion> collect() => {
        if (potion is Potion) label: potion!,
      };

  //</editor-fold>

  @override
  String toString() => '$runtimeType[$label] — $potion';
}
