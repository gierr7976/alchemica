part of alchemica.bypass;

class BypassDispatcher {
  static FutureOr<void> voidMagic(_, __) => null;

  final List<BypassOut> _consumers = [];
  final List<MagicPerformer> _allowed = [];

  Ingredient? _latestIngredient;

  BypassDispatcher();

  void addConsumer(BypassOut consumer) => _consumers.add(consumer);

  void removeConsumer(BypassOut consumer) => _consumers.remove(consumer);

  void allow<I extends Ingredient>() => _allowed.add(MagicPerformer(voidMagic));

  void clearAllowed() => _allowed.clear();

  void pass(BypassIn source, Ingredient ingredient) {
    if (_latestIngredient == ingredient) return _latestIngredient = null;
    _latestIngredient = ingredient;

    if (_allowed.any((allowed) => !allowed.check(ingredient))) return;

    bypass(source, ingredient);
  }

  @protected
  void bypass(BypassIn source, Ingredient ingredient) {
    for (BypassOut consumer in _consumers)
      if (consumer.label == source.label) consumer.pass(ingredient);
  }
}
