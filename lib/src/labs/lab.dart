part of alchemica.labs;

class Lab extends StatefulWidget {
  final Widget child;
  final Recipe recipe;

  static LabState of(BuildContext context) =>
      context.findAncestorStateOfType()!;

  const Lab({
    Key? key,
    required this.recipe,
    required this.child,
  }) : super(key: key);

  @override
  LabState createState() => LabState();
}

class LabState extends State<Lab> {
  final RootPipe _root = RootPipe();

  Recipe? _currentRecipe;

  @override
  void initState() {
    super.initState();

    prepare(widget.recipe);
  }

  void prepare(Recipe recipe) {
    final Pipe rootChild = recipe.prepareLab();
    _root.updateChild(rootChild);
    _currentRecipe = recipe;
  }

  F? find<R extends Recipe, F extends Flask>([Label? label]) {
    if (_currentRecipe is! R) throw RecipeError<R, F>(_currentRecipe);

    return _root.find(label);
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    super.dispose();
    _root.dispose();
  }
}

class RecipeError<R extends Recipe, F extends Flask> extends StateError {
  RecipeError(Recipe? current)
      : super('Unable to find $F for $R in ${current.runtimeType}');
}
