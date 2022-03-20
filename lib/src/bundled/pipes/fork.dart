part of alchemica.bundled.pipes;

class Fork extends Pipe {
  final Label? _label;

  @override
  Label get label => _label ?? super.label;

  final List<Pipe> children;

  Fork({
    Label? label,
    required this.children,
  }) : _label = label;

  @override
  void install(PipeContext context) {
    for (Pipe child in children) child.install(context.inherit(child));
  }

  @override
  void pass(Ingredient ingredient) {
    for (Pipe child in children) child.pass(ingredient);
  }

  @override
  void uninstall() {
    for (Pipe child in children) child.uninstall();
  }

  @override
  P? find<P extends Pipe>([Label? label]) {
    for (Pipe child in children) {
      final P? fromChild = child.find(label);

      if (fromChild is P) return fromChild;
    }

    return super.find(label);
  }

  @override
  Map<Label, Potion> collect() => {
        ...super.collect(),
        for (Pipe child in children) ...child.collect(),
      };
}
