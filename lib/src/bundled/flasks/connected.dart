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

  @protected
  void passInternal(Ingredient ingredient) => super.pass(ingredient);

  @override
  void uninstall() {
    child?.uninstall();
    super.uninstall();
  }

  @override
  P? find<P extends Pipe>([Label? label]) {
    final P? maybeThis = super.find(label);

    return maybeThis ?? child?.find(label);
  }

  @override
  Map<Label, Potion> collect() => {
        ...super.collect(),
        ...child?.collect() ?? {},
      };
}
