part of alchemica.bypass;

class BypassDispatcher {
  final List<BypassOut> _consumers = [];

  void addConsumer(BypassOut consumer) => _consumers.add(consumer);

  void removeConsumer(BypassOut consumer) => _consumers.remove(consumer);

  void pass(BypassIn source, Ingredient ingredient) {
    for (BypassOut consumer in _consumers)
      if (consumer.label == source.label) consumer.pass(ingredient);
  }
}
