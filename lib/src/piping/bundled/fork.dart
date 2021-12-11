part of alchemica.piping;

class Fork extends Pipe {
  final Label? _label;
  final List<Pipe> children;

  @override
  Label get label => _label ?? Label.type(this);

  Fork({
    Label? label,
    required this.children,
  }) : _label = label;

  @override
  void drip(PipeContext context) {
    for (Pipe child in children) child.drip(context.derivative(child));
  }

  @override
  Map<Label, Pipe> extract() => {
        label: this,
        for (Pipe child in children) ...child.extract(),
      };

  @override
  T? find<T extends Pipe>([Label? label]) {
    final Label maybeThisLabel = label ?? this.label;

    if (this is T && this.label == maybeThisLabel) return this as T;

    for (Pipe child in children) {
      final T? fromChild = child.find(label);
      if (fromChild is T) return fromChild;
    }
  }
}
