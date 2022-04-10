part of alchemica.piping;

abstract class Pipe with Labelable {
  Potion? get potion => null;

  //<editor-fold desc="Lifecycle methods">

  void install(PipeContext context);

  void pass(Ingredient ingredient);

  void uninstall();

  //</editor-fold>

  //<editor-fold desc="Extraction methods">

  P? _conditional<P extends Pipe>([Label? label]) {
    if (this is P) {
      final Label suggested = label ?? this.label;

      if (this.label == suggested) return this as P;
    }

    return null;
  }

  @mustCallSuper
  P? find<P extends Pipe>([Label? label]) => _conditional(label);

  @mustCallSuper
  Map<Label, Potion> collect() => {
        if (potion is Potion) label: potion!,
      };

  //</editor-fold>

  @override
  String toString() => '$runtimeType[$label] — $potion';
}
