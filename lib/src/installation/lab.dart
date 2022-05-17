part of alchemica.installation;

// ignore_for_file: deprecated_member_use_from_same_package

@Deprecated('Will be removed after Q2 2022')
typedef KeyWidgetBuilder = Widget Function(
  BuildContext context,
  GlobalKey<LabState> key,
);

class Lab extends LabBase {
  static LabState of(BuildContext context) =>
      context.findAncestorStateOfType()!;

  final Widget? child;

  @Deprecated('Will be removed after Q2 2022')
  final KeyWidgetBuilder? builder;

  const Lab({
    Key? key,
    this.child,
    this.builder,
    required Recipe recipe,
    FuseDispatcher? fuseDispatcher,
    BypassDispatcher? bypassDispatcher,
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
        super(
          key: key,
          recipe: recipe,
          fuseDispatcher: fuseDispatcher,
          bypassDispatcher: bypassDispatcher,
        );

  @override
  State<StatefulWidget> createState() => LabState();
}

class LabState extends LabBaseState<Lab> {
  @override
  void initState() {
    super.initState();

    buildRecipe();
  }

  @override
  void didUpdateWidget(covariant Lab oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(
      () => buildRecipe(),
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
