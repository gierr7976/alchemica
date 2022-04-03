part of alchemica.installation;

typedef KeyWidgetBuilder = Widget Function(
  BuildContext context,
  GlobalKey<LabState> key,
);

class Lab extends StatefulWidget {
  static LabState of(BuildContext context) =>
      context.findAncestorStateOfType()!;

  final Widget? child;
  final KeyWidgetBuilder? builder;
  final BypassDispatcher bypassDispatcher;
  final FuseDispatcher fuseDispatcher;
  final Recipe recipe;

  Lab({
    Key? key,
    required this.recipe,
    this.child,
    this.builder,
    BypassDispatcher? bypassDispatcher,
    FuseDispatcher? fuseDispatcher,
  })  : bypassDispatcher = bypassDispatcher ?? BypassDispatcher(),
        fuseDispatcher = fuseDispatcher ?? FuseDispatcher(),
        assert(
          (child is Widget) ^ (builder is KeyWidgetBuilder),
          'Either child or builder must be provided!',
        ),
        assert(
          builder is KeyWidgetBuilder ? key is GlobalKey<LabState> : true,
          '''
          Key must be an instance of GlobalKey<LabState> 
          if builder is provided!\n
          
          Did you forgot to add this one?
          ''',
        ),
        super(key: key);

  @override
  State<StatefulWidget> createState() => LabState();
}

class LabState extends State<Lab> {
  Recipe? _recipe;

  Recipe get recipe {
    shallBeInitialized();

    return _recipe!;
  }

  set recipe(Recipe recipe) {
    _recipe = recipe;
    buildRecipe();
  }

  Pipe? _rootElement;

  @override
  void initState() {
    super.initState();
    recipe = widget.recipe;
  }

  @override
  void didUpdateWidget(covariant Lab oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(
      () => recipe = widget.recipe,
    );
  }

  void shallBeBuilt() {
    shallBeInitialized();

    if (_rootElement == null) throw StateError('Recipe shall be built first!');
  }

  void shallBeInitialized() {
    if (_recipe == null) throw StateError('Shall be initialized first!');
  }

  P require<P extends Pipe>([Label? label]) {
    final P? suggested = prefer(label);
    if (suggested is P) return suggested;

    throw StateError('Required element is not presented!');
  }

  P? prefer<P extends Pipe>([Label? label]) {
    shallBeBuilt();

    final P? suggested = _rootElement!.find(label);
    if (suggested is P) return suggested;

    return null;
  }

  void add(Ingredient ingredient) {
    shallBeBuilt();

    _rootElement!.pass(ingredient);
  }

  void buildRecipe() {
    shallBeInitialized();

    final Map<Label, Potion>? preserved = _rootElement?.collect();
    _rootElement?.uninstall();
    _rootElement = recipe.build();
    widget.bypassDispatcher.clearAllowed();
    _rootElement!.install(
      PipeContext(
        current: _rootElement!,
        bypassDispatcher: widget.bypassDispatcher,
        fuseDispatcher: widget.fuseDispatcher,
        preserved: preserved,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child is Widget
      ? widget.child!
      : widget.builder!(
          context,
          widget.key as GlobalKey<LabState>,
        );

  @override
  void dispose() {
    _rootElement?.uninstall();
    super.dispose();
  }
}
