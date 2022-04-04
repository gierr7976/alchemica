part of alchemica.bypass;

abstract class Bypass extends Pipe {
  final Pipe? child;

  @override
  final Label label;

  BypassDispatcher? _dispatcher;

  bool get isInstalled => _dispatcher is BypassDispatcher;

  BypassDispatcher get dispatcher {
    shallBeInstalled();

    return _dispatcher!;
  }

  Bypass({
    required this.label,
    this.child,
  });

  @override
  @mustCallSuper
  void install(PipeContext context) {
    _dispatcher = context.bypassDispatcher;
    child?.install(context.inherit(child!));
  }

  @override
  @mustCallSuper
  void pass(Ingredient ingredient) {
    child?.pass(ingredient);
  }

  @override
  @mustCallSuper
  void uninstall() {
    _dispatcher = null;
    child?.uninstall();
  }

  @override
  P? find<P extends Pipe>([Label? label]) {
    final P? maybeThis = super.find(label);

    return maybeThis ?? child?.find(label);
  }

  @override
  Map<Label, Potion> collect() => {
        ...super.collect(),
        ...(child?.collect() ?? {}),
      };

  void shallBeInstalled() {
    if (!isInstalled) throw StateError('Shall be installed first!');
  }
}

class BypassIn extends Bypass {
  BypassIn({
    required Label label,
    Pipe? child,
  }) : super(
          label: label,
          child: child,
        );

  @override
  void install(PipeContext context) {
    checkContext(context);

    super.install(context);
  }

  void checkContext(PipeContext context) {
    final BypassIn? other = context.lookup(null, true);
    if (other is BypassIn)
      throw StateError('Multiple BypassIn in same context!');
  }

  @override
  void pass(Ingredient ingredient) {
    dispatcher.pass(this, ingredient);
    super.pass(ingredient);
  }
}

class BypassOut extends Bypass {
  final List<MagicPerformer> allowed;

  BypassOut({
    required Label label,
    required this.allowed,
    Pipe? child,
  }) : super(
          label: label,
          child: child,
        );

  @override
  void install(PipeContext context) {
    super.install(context);
    dispatcher.addConsumer(this);
  }

  void _bypass(Ingredient ingredient) {
    if (allowed.any((performer) => performer.check(ingredient)))
      pass(ingredient);
  }

  @override
  void uninstall() {
    dispatcher.removeConsumer(this);
    super.uninstall();
  }

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => identityHashCode(this);
}
