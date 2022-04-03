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
    child?.install(context.inherit(child!));
    _dispatcher = context.bypassDispatcher;
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
  BypassOut({
    required Label label,
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
