part of alchemica.flasks;

abstract class Flask extends Pipe {
  FlaskBloc? bloc;

  @override
  Label get label => _label ?? super.label;

  @override
  Potion? get potion => bloc?.state;

  final Label? _label;

  final List<Type> _usedIngredients = [];

  Flask({
    Label? label,
  }) : _label = label;

  //<editor-fold desc="Installation methods">

  @override
  void install(PipeContext context) {
    dependencies(context);

    bloc = FlaskBloc(initial: brewInitial(context), onMutation: onMutation);

    uses();
  }

  void dependencies(PipeContext context) {
    // Intentionally left blank
  }

  void uses();

  Potion brewInitial(PipeContext context) =>
      context.getPreserved(label) ?? UnderbrewedPotion();

  @protected
  void use<I extends Ingredient>(
    Magic<I> magic, {
    EventTransformer<I>? transformer,
  }) {
    shallBeInstalled();

    _usedIngredients.add(I);
    bloc!.use(magic, transformer);
  }

  //</editor-fold>

  //<editor-fold desc="Behavior methods">

  @protected
  void onMutation(Potion potion) {
    // Intentionally left blank
  }

  @override
  void pass(Ingredient ingredient) {
    shallBeInstalled();

    if (_usedIngredients.contains(ingredient.runtimeType))
      bloc!.add(ingredient);
  }

  //</editor-fold>

  //<editor-fold desc="Uninstallation methods">

  @override
  void uninstall() {
    bloc?.close();
  }

  //</editor-fold>

  //<editor-fold desc="Checks">

  @protected
  void shallBeInstalled() {
    if (bloc == null) throw StateError('Shall be installed first!');
  }

  @protected
  P require<P extends Potion>() {
    shallBeInstalled();

    if (potion is! P) throw StateError('Incorrect potion: $potion');

    return potion as P;
  }

  @protected
  P? prefer<P extends Potion>() {
    shallBeInstalled();

    return potion is P ? potion as P : null;
  }
//</editor-fold>
}
