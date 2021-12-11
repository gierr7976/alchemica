part of alchemica.flasks;

@immutable
abstract class Ingredient {
  const Ingredient();
}

abstract class AlchemistIngredient extends Ingredient {
  const AlchemistIngredient();
}

abstract class FlaskIngredient extends Ingredient {
  const FlaskIngredient();
}

class PoisonedIngredient extends FlaskIngredient {
  final Explosion poisoner;

  const PoisonedIngredient(this.poisoner);
}

class DrippedIngredient<T extends Potion> extends FlaskIngredient {
  final T dripped;

  const DrippedIngredient(this.dripped);
}
