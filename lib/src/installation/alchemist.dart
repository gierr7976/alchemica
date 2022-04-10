part of alchemica.installation;

class Alchemist {
  BypassDispatcher _bypassDispatcher;
  FuseDispatcher _fuseDispatcher;

  Pipe? _root;

  Pipe get root {
    shallBeBuilt();

    return _root!;
  }

  Alchemist({
    BypassDispatcher? bypassDispatcher,
    FuseDispatcher? fuseDispatcher,
  })  : _bypassDispatcher = bypassDispatcher ?? BypassDispatcher(),
        _fuseDispatcher = fuseDispatcher ?? FuseDispatcher();

  //<editor-fold desc="Build methods">

  void buildFor({
    required Recipe recipe,
    BypassDispatcher? bypassDispatcher,
    FuseDispatcher? fuseDispatcher,
  }) {
    _bypassDispatcher = bypassDispatcher ?? _bypassDispatcher;
    _fuseDispatcher = fuseDispatcher ?? _fuseDispatcher;

    Map<Label, Potion>? preserved = _root?.collect();
    _root = recipe.build();
    _root!.install(
      _makeContext(preserved),
    );
  }

  PipeContext _makeContext(Map<Label, Potion>? preserved) => PipeContext(
        current: _root!,
        bypassDispatcher: _bypassDispatcher,
        fuseDispatcher: _fuseDispatcher,
        preserved: preserved,
      );

  //</editor-fold>

  void add(AlchemistIngredient ingredient) {
    shallBeBuilt();

    _root!.pass(ingredient);
  }

  //<editor-fold desc="Search methods">

  P require<P extends Pipe>([Label? label]) {
    final P? suggested = prefer(label);
    if (suggested is P) return suggested;

    throw StateError('Required element is not presented!');
  }

  P? prefer<P extends Pipe>([Label? label]) {
    shallBeBuilt();

    final P? suggested = _root!.find(label);
    if (suggested is P) return suggested;

    return null;
  }

  //</editor-fold>

  //<editor-fold desc="Checks">

  void shallBeBuilt() {
    if (_root is! Pipe) throw StateError('Shall be built first!');
  }

//</editor-fold>
}
