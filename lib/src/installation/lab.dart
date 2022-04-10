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
  late final Alchemist _alchemist;

  P require<P extends Pipe>([Label? label]) => _alchemist.require(label);

  P? prefer<P extends Pipe>([Label? label]) => _alchemist.prefer(label);

  void add(AlchemistIngredient ingredient) => _alchemist.add(ingredient);

  @override
  void initState() {
    super.initState();

    _alchemist = Alchemist(
      bypassDispatcher: widget.bypassDispatcher,
      fuseDispatcher: widget.fuseDispatcher,
    );
    _alchemist.buildFor(recipe: widget.recipe);
  }

  @override
  void didUpdateWidget(covariant Lab oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(
      () => _alchemist.buildFor(
        recipe: widget.recipe,
        bypassDispatcher: widget.bypassDispatcher,
        fuseDispatcher: widget.fuseDispatcher,
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
    _alchemist.uninstall();
    super.dispose();
  }
}
