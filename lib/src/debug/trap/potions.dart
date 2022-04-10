part of alchemica.debug.trap;

class BrewedTrap extends BrewedPotion {
  final List<Ingredient> caught;

  BrewedTrap({
    required this.caught,
  });

  @override
  BrewedTrap copyWith({
    List<Ingredient>? caught,
  }) =>
      BrewedTrap(
        caught: caught ?? this.caught,
      );
}
