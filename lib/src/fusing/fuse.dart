part of alchemica.fusing;

typedef Fusible = void Function();

typedef AsyncFusible = FutureOr<void> Function();

class Fuse {
  final bool enabled;
  final List<PoisonHandler> handlers;

  PoisonHandler get _firstHandler => handlers.first;

  Fuse([this.enabled = true]) : handlers = [PoisonedPotionBrewer()];

  Fuse.handled({
    required List<PoisonHandler> handlers,
    this.enabled = true,
  }) : handlers = [
          PoisonedPotionBrewer(),
          ...handlers,
        ] {
    _linkHandlers();
  }

  void _linkHandlers() {
    for (int i = 0; i < handlers.length - 1; i++)
      handlers[i]._next = handlers[i + 1];
  }

  PoisonedPotion? fuse(Fusible fusible) {
    try {
      fusible();
    } catch (poison, stackTrace) {
      if (enabled) return _firstHandler.handle(poison, stackTrace);

      rethrow;
    }

    return null;
  }

  Future<PoisonedPotion?> fuseAsync(AsyncFusible fusible) async {
    try {
      await fusible();
    } catch (poison, stackTrace) {
      if (enabled) return _firstHandler.handle(poison, stackTrace);

      rethrow;
    }

    return null;
  }
}
