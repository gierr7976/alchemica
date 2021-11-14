part of flasks;

@immutable
abstract class Ingredient {
  const Ingredient();
}

abstract class AlchemistIngredient extends Ingredient {
  const AlchemistIngredient();
}

@protected
abstract class FlaskIngredient extends Ingredient {
  const FlaskIngredient();
}

abstract class MedianIngredient extends Ingredient {
  const MedianIngredient();
}

abstract class FinalIngredient extends Ingredient {
  const FinalIngredient();
}

class PoisonedIngredient extends FlaskIngredient {
  final Explosion poisoner;

  const PoisonedIngredient(this.poisoner);
}

class DrippedIngredient extends FlaskIngredient {
  final Potion mutation;

  const DrippedIngredient(this.mutation);
}
