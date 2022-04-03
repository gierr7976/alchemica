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
  final BypassDispatcher? bypassDispatcher;
  final Recipe recipe;

  const Lab({
    Key? key,
    required this.recipe,
    this.child,
    this.builder,
    this.bypassDispatcher,
  })  : assert(
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

  BypassDispatcher? _bypassDispatcher;

  BypassDispatcher get bypassDispatcher {
    shallBeInitialized();

    return _bypassDispatcher!;
  }

  Pipe? _rootElement;

  Pipe get rootElement {
    shallBeBuilt();
    return _rootElement!;
  }

  @override
  void initState() {
    super.initState();
    _bypassDispatcher = widget.bypassDispatcher ?? BypassDispatcher();
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
    if (_rootElement == null) throw StateError('Recipe shall be built first!');
  }

  void shallBeInitialized() {
    if (_recipe == null || _bypassDispatcher == null)
      throw StateError('Shall be initialized first!');
  }

  P require<P extends Pipe>([Label? label]) {
    final P? suggested = prefer(label);
    if (suggested is P) return suggested;

    throw StateError('Required element is not presented!');
  }

  P? prefer<P extends Pipe>([Label? label]) {
    final P? suggested = rootElement.find(label);
    if (suggested is P) return suggested;

    return null;
  }

  void add(Ingredient ingredient) {
    rootElement.pass(ingredient);
  }

  void buildRecipe() {
    final Map<Label, Potion>? preserved = _rootElement?.collect();
    _rootElement = recipe.build();
    _rootElement!.install(
      PipeContext(
        current: _rootElement!,
        bypassDispatcher: bypassDispatcher,
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
}
