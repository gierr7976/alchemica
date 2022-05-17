part of alchemica.installation;

abstract class LabBase extends StatefulWidget {
  static LabState of(BuildContext context) =>
      context.findAncestorStateOfType()!;

  final Recipe recipe;
  final FuseDispatcher? fuseDispatcher;
  final BypassDispatcher? bypassDispatcher;

  const LabBase({
    Key? key,
    required this.recipe,
    required this.fuseDispatcher,
    required this.bypassDispatcher,
  }) : super(key: key);
}

abstract class LabBaseState<L extends LabBase> extends State<L> {
  late final Alchemist _alchemist = Alchemist();

  P require<P extends Pipe>([Label? label]) => _alchemist.require(label);

  P? prefer<P extends Pipe>([Label? label]) => _alchemist.prefer(label);

  void add(AlchemistIngredient ingredient) => _alchemist.add(ingredient);

  @protected
  @mustCallSuper
  void buildRecipe([Recipe? recipe]) => recipe is Recipe
      ? _alchemist.build(
          recipe: recipe,
          bypassDispatcher: widget.bypassDispatcher,
          fuseDispatcher: widget.fuseDispatcher,
        )
      : _alchemist.uninstall();

  @override
  void dispose() {
    _alchemist.uninstall();
    super.dispose();
  }
}
