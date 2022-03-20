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
  Recipe get _recipe => widget.recipe;

  Pipe? _rootElement;

  @override
  void initState() {
    super.initState();
    rebuildRecipe();
  }

  @override
  void didUpdateWidget(covariant Lab oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(rebuildRecipe);
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

  void rebuildRecipe() => _recipe.build();

  @override
  Widget build(BuildContext context) => widget.child;
}
