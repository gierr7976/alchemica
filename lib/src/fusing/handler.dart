part of alchemica.fusing;

abstract class PoisonHandler {
  PoisonHandler? _next;

  PoisonHandler? get next => _next;

  PoisonedPotion? handle(Object poison, StackTrace stackTrace);
}

class PoisonedPotionBrewer extends PoisonHandler {
  @override
  PoisonedPotion? handle(Object poison, StackTrace stackTrace) =>
      next?.handle(poison, stackTrace) ??
      PoisonedPotion(
        poison: poison,
        stackTrace: stackTrace,
      );
}
