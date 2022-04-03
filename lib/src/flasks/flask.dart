part of alchemica.flasks;

abstract class Flask extends Pipe {
  @override
  Label get label => _label ?? super.label;

  final Label? _label;

  //<editor-fold desc="State guarded">

  @override
  Potion? get potion => bloc.state;

  FlaskBloc get bloc {
    shallBeInstalled();

    return _bloc!;
  }

  List<IngredientScanner> get scanners {
    shallBeInstalled();

    return _scanners!;
  }

  List<IngredientScanner>? _scanners;

  FlaskBloc? _bloc;

  //</editor-fold>

  Flask({
    Label? label,
  }) : _label = label;

  //<editor-fold desc="Installation methods">

  @override
  void install(PipeContext context) {
    dependencies(context);

    _bloc = FlaskBloc(initial: brewInitial(context), onMutation: onMutation);
    _scanners = [];

    usages();
  }

  @protected
  void dependencies(PipeContext context) {
    // Intentionally left blank
  }

  @protected
  void usages();

  @protected
  Potion brewInitial(PipeContext context) =>
      context.getPreserved(label) ?? UnderbrewedPotion();

  //<editor-fold desc="Usage binders">

  @protected
  void use<I extends Ingredient>(
    Magic<I> magic, {
    EventTransformer<I>? transformer,
  }) {
    scanners.add(IngredientScanner<I>());
    bloc.use(magic, transformer);
  }

  void useDripped<D extends Pipe, P extends Potion>(
    Magic<DrippedIngredient> magic, {
    EventTransformer<DrippedIngredient>? transformer,
  }) {
    scanners.add(DrippedIngredientScanner<D, P>());
    bloc.use(magic, transformer);
  }

  //</editor-fold>

  //</editor-fold>

  //<editor-fold desc="Behavior methods">

  @protected
  void onMutation(Potion potion) {
    // Intentionally left blank
  }

  @override
  void pass(Ingredient ingredient) {
    for (IngredientScanner scanner in scanners)
      if (scanner.check(ingredient)) {
        bloc.add(ingredient);
        return;
      }
  }

  //</editor-fold>

  //<editor-fold desc="Uninstallation methods">

  @override
  void uninstall() {
    bloc.close();
  }

  //</editor-fold>

  //<editor-fold desc="Checks">

  @protected
  void shallBeInstalled() {
    if (_bloc is! FlaskBloc) throw StateError('Shall be installed first!');
  }

  @protected
  P require<P extends Potion>() {
    if (potion is! P) throw StateError('Incorrect potion: $potion');

    return potion as P;
  }

  @protected
  P? prefer<P extends Potion>() {
    return potion is P ? potion as P : null;
  }
//</editor-fold>
}
