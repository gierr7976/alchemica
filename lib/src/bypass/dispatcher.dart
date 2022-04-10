part of alchemica.bypass;

class BypassDispatcher {
  final List<BypassOut> _consumers = [];

  Ingredient? _latestIngredient;

  BypassDispatcher();

  @mustCallSuper
  void addConsumer(BypassOut consumer) => _consumers.add(consumer);

  @mustCallSuper
  void removeConsumer(BypassOut consumer) => _consumers.remove(consumer);

  @mustCallSuper
  void pass(BypassIn source, Ingredient ingredient) {
    if (identical(_latestIngredient, ingredient)) return;
    _latestIngredient = ingredient;

    _bypass(source, ingredient);
  }

  @protected
  void _bypass(BypassIn source, Ingredient ingredient) {
    for (BypassOut consumer in _consumers)
      if (consumer.label == source.label) consumer._bypass(ingredient);
  }
}
