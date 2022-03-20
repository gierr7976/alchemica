part of alchemica.preparations;

abstract class Potion implements Prototype {
  const Potion();

  @override
  Potion copyWith();
}

class UnderbrewedPotion extends Potion {
  const UnderbrewedPotion();

  @override
  UnderbrewedPotion copyWith() => UnderbrewedPotion();
}

abstract class BrewedPotion extends Potion {
  const BrewedPotion();

  @override
  BrewedPotion copyWith();
}

class PoisonedPotion extends Potion {
  final Object poison;
  final StackTrace stackTrace;

  const PoisonedPotion({
    required this.poison,
    required this.stackTrace,
  });

  @override
  PoisonedPotion copyWith({
    Object? poison,
    StackTrace? stackTrace,
  }) =>
      PoisonedPotion(
        poison: poison ?? this.poison,
        stackTrace: stackTrace ?? this.stackTrace,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PoisonedPotion &&
          runtimeType == other.runtimeType &&
          poison == other.poison &&
          stackTrace == other.stackTrace;

  @override
  int get hashCode => poison.hashCode ^ stackTrace.hashCode;
}
