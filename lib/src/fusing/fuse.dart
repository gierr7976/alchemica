part of alchemica.fusing;

typedef Fusible = void Function();

typedef AsyncFusible = FutureOr<void> Function();

class Fuse {
  final bool enabled;

  Fuse([this.enabled = true]);

  PoisonedPotion? fuse(Fusible fusible) {
    try {
      fusible();
    } catch (poison, stackTrace) {
      if (enabled)
        return PoisonedPotion(
          poison: poison,
          stackTrace: stackTrace,
        );

      rethrow;
    }

    return null;
  }

  Future<PoisonedPotion?> fuseAsync(AsyncFusible fusible) async {
    try {
      await fusible();
    } catch (poison, stackTrace) {
      if (enabled)
        return PoisonedPotion(poison: poison, stackTrace: stackTrace);

      rethrow;
    }

    return null;
  }
}
