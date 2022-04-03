part of alchemica.flasks;

class MagicPerformer<I extends Ingredient> {
  final Magic<I> magic;

  MagicPerformer(this.magic);

  bool check(Ingredient ingredient) => ingredient is I;

  FutureOr<void> perform(Ingredient ingredient, Emitter<Potion> emit) =>
      magic(ingredient as I, emit);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MagicPerformer && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

class DrippedMagicPerformer<D extends Pipe, P extends Potion>
    extends MagicPerformer<DrippedIngredient> {
  DrippedMagicPerformer(
    Magic<DrippedIngredient> magic,
  ) : super(magic);

  @override
  bool check(Ingredient ingredient) {
    if (ingredient is DrippedIngredient)
      return ingredient._dripper is D && ingredient._potion is P;

    return false;
  }
}
