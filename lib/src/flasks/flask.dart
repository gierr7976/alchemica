part of alchemica.flasks;

abstract class Flask extends Pipe {
  @override
  Label get label => _label ?? super.label;

  final Label? _label;

  //<editor-fold desc="State guarded">

  @override
  Potion get potion => bloc.state;

  FlaskBloc get bloc {
    shallBeInstalled();

    return _bloc!;
  }

  FlaskBloc? _bloc;

  List<MagicPerformer>? _performers;

  bool get isInstalled =>
      _bloc is FlaskBloc && _performers is List<MagicPerformer>;

  //</editor-fold>

  Flask({
    Label? label,
  }) : _label = label;

  //<editor-fold desc="Installation methods">

  @override
  void install(PipeContext context) {
    dependencies(context);

    _bloc = FlaskBloc(
      initial: brewInitial(context),
      onMutation: onMutation,
      fuse: context.fuseDispatcher.fuse,
    );
    _bloc!.install();
    _bloc!.use<DrippedIngredient>(onDripped, null);

    _performers = [];

    usages();
  }

  @protected
  void dependencies(PipeContext context) {
    // Intentionally left blank
  }

  @protected
  void usages() {
    // Intentionally left blank
  }

  @protected
  Potion brewInitial(PipeContext context) =>
      context.getPreserved(label) ?? UnderbrewedPotion();

  //<editor-fold desc="Usage binders">

  @protected
  void use<I extends Ingredient>(
    Magic<I> magic, {
    EventTransformer<I>? transformer,
  }) {
    shallBeInstalled();

    final bool performerAdded = addPerformer(MagicPerformer<I>(magic));
    if (performerAdded) _bloc!.use(magic, transformer);
  }

  @protected
  void useDripped<D extends Pipe, P extends Potion>(
    Magic<DrippedIngredient> magic, {
    EventTransformer<DrippedIngredient>? transformer,
  }) {
    shallBeInstalled();

    addPerformer(DrippedMagicPerformer<D, P>(magic));
  }

  @protected
  bool addPerformer(MagicPerformer performer) {
    shallBeInstalled();

    if (_performers!.any((registered) => performer == registered)) return false;

    _performers!.add(performer);
    return true;
  }

  @protected
  FutureOr<void> onDripped(DrippedIngredient ingredient, Emitter<Potion> emit) {
    for (MagicPerformer performer in _performers!)
      if (performer.check(ingredient))
        return performer.perform(ingredient, emit);
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
    shallBeInstalled();

    for (MagicPerformer scanner in _performers!)
      if (scanner.check(ingredient)) {
        _bloc!.add(ingredient);
        return;
      }
  }

  //</editor-fold>

  //<editor-fold desc="Uninstallation methods">

  @override
  @mustCallSuper
  void uninstall() async {
    bloc.close();
    _performers = null;
  }

  //</editor-fold>

  //<editor-fold desc="Checks">

  @protected
  void shallBeInstalled() {
    if (!isInstalled) throw StateError('Shall be installed first!');
  }

  P require<P extends Potion>() {
    if (potion is! P) throw StateError('Incorrect potion: $potion');

    return potion as P;
  }

  P? prefer<P extends Potion>() {
    return potion is P ? potion as P : null;
  }
//</editor-fold>
}
