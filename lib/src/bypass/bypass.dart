part of alchemica.bypass;

abstract class Bypass extends Pipe {
  final Pipe? child;

  @override
  final Label label;

  BypassDispatcher? _controller;

  BypassDispatcher get controller {
    shallBeInstalled();

    return _controller!;
  }

  Bypass({
    required this.label,
    this.child,
  });

  @override
  @mustCallSuper
  void install(PipeContext context) {
    child?.install(context.inherit(child!));
    // TODO: implement controller handling
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
    if (_controller is! BypassDispatcher)
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
    controller.pass(this, ingredient);
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
    controller.addConsumer(this);
  }

  @override
  void uninstall() {
    controller.removeConsumer(this);
    super.uninstall();
  }
}
