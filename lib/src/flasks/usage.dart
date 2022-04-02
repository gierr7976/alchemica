part of alchemica.flasks;

class IngredientScanner<I extends Ingredient> {
  bool check(Ingredient ingredient) => ingredient is I;
}

class DrippedIngredientScanner<D extends Pipe, P extends Potion>
    extends IngredientScanner<DrippedIngredient> {
  @override
  bool check(Ingredient ingredient) {
    if (ingredient is DrippedIngredient)
      return ingredient._dripper is D && ingredient._potion is P;

    return false;
  }
}
