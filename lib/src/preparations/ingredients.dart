part of alchemica.preparations;

abstract class Ingredient implements Prototype {
  const Ingredient();

  @override
  Ingredient copyWith();
}

abstract class AlchemistIngredient extends Ingredient {
  const AlchemistIngredient();

  @override
  AlchemistIngredient copyWith();
}

abstract class PipeIngredient extends Ingredient {
  const PipeIngredient();

  @override
  PipeIngredient copyWith();
}
