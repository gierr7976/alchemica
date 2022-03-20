part of alchemica.bundled.flasks;

abstract class ConnectedFlask extends Flask {
  final Pipe? child;

  ConnectedFlask({
    Label? label,
    this.child,
  }) : super(label: label);

  @override
  void install(PipeContext context) {
    super.install(context);

    if (child is Pipe) child!.install(context.inherit(child!));
  }

  @override
  @protected
  void onMutation(Potion potion) {
    child?.pass(
      DrippedIngredient(
        dripper: this,
        potion: potion,
      ),
    );
  }

  @override
  void pass(Ingredient ingredient) {
    super.pass(ingredient);
    child?.pass(ingredient);
  }

  @override
  void uninstall() {
    child?.uninstall();
    super.uninstall();
  }
}
