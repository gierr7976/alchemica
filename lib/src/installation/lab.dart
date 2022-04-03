part of alchemica.installation;

class Lab extends StatefulWidget {
  static LabState of(BuildContext context) =>
      context.findAncestorStateOfType()!;

  final Widget child;
  final Recipe recipe;

  const Lab({
    Key? key,
    required this.child,
    required this.recipe,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LabState();
}

class LabState extends State<Lab> {
  Recipe? _recipe;

  Recipe get recipe => _recipe!;

  set recipe(Recipe recipe) {
    _recipe = recipe;
    rebuildRecipe();
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

  void requireRoot() {
    if (_rootElement == null) throw StateError('Recipe shall be built first!');
  }

  P require<P extends Pipe>([Label? label]) {
    final P? suggested = prefer(label);
    if (suggested is P) return suggested;

    throw StateError('Required element is not presented!');
  }

  P? prefer<P extends Pipe>([Label? label]) {
    requireRoot();

    final P? suggested = _rootElement?.find(label);
    if (suggested is P) return suggested;

    return null;
  }

  void add(Ingredient ingredient) {
    requireRoot();

    _rootElement!.pass(ingredient);
  }

  void rebuildRecipe() {
    final Map<Label, Potion>? preserved = _rootElement?.collect();
    _rootElement = recipe.build();
    _rootElement!.install(
      PipeContext(
        current: _rootElement!,
        preserved: preserved,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
