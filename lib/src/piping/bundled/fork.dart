part of alchemica.piping;

/// A [Pipe] element containing multiple downstream elements.
class Fork extends Pipe {
  /// Label given with constructor.
  final Label? _label;

  /// Downstream elements of this element.
  ///
  /// *Note: [children] is not preserved over logic tree mutations.*
  final List<Pipe> children;

  @override
  Label get label => _label ?? Label.type(this);

  /// Default constructor.
  Fork({
    Label? label,
    required this.children,
  }) : _label = label;

  @override
  void drip(PipeContext context) {
    for (Pipe child in children) child.drip(context._derivative(child));
  }

  // TODO: add unit test
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

  @override
  void dispose() {
    for (Pipe child in children) child.dispose();
  }
}
