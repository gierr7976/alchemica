part of alchemica.debug.trap;

class BrewedTrap extends BrewedPotion {
  final List<Ingredient> caught;

  BrewedTrap({
    required this.caught,
  });

  BrewedTrap copyWith({
    List<Ingredient>? caught,
  }) =>
      BrewedTrap(
        caught: caught ?? this.caught,
      );

  @override
  String toString() {
    const String title = 'BrewedTrap [\n';
    const String end = ']';

    final List<String> ingredients = [];
    for (int i = 0; i < caught.length; i++)
      ingredients.add('\t$i: ${caught[i].toString()}\n');

    return title + ingredients.join() + end;
  }
}
