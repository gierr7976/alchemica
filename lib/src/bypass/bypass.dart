part of alchemica.bypass;

abstract class Bypass extends Pipe {
  final Pipe? child;

  @override
  final Label label;

  BypassDispatcher? _dispatcher;

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
    loopCheck(context);

    child?.install(context.inherit(child!));
    _dispatcher = context.bypassDispatcher;
  }

  @protected
  void loopCheck(PipeContext context) {
    Bypass? bypass = context.lookup(label);
    if (bypass is Bypass) throw StateError('Looped bypass: $label');
  }

  @override
  @mustCallSuper
  void pass(Ingredient ingredient) {
    child?.pass(ingredient);
  }

  @override
  @mustCallSuper
  void uninstall() {
    child?.uninstall();
  }

  void shallBeInstalled() {
    if (_dispatcher is! BypassDispatcher)
      throw StateError('Shall be installed first!');
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
