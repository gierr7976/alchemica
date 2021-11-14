part of flasks;

typedef Magic<I extends Ingredient> = FutureOr<void> Function(
    I ingredient, Emitter emit);

abstract class Flask extends Bloc<Ingredient, Potion> with Tap {
  @protected
  final Fuse fuse = GetIt.instance();

  Flask() : super(UnderbrewedPotion()) {
    use(_useDripped);
  }

  @protected
  void use<I extends Ingredient>(
    Magic<I> magic, [
    EventTransformer<I>? transformer,
  ]) {
    on<I>(
      (event, emit) async {
        OccasionalExplosion? poisoner = await fuse.fuseAsync(
          () => magic(event, emit),
        );

        if (poisoner != null)
          emit(
            PoisonedPotion(poisoner),
          );
      },
      transformer: transformer,
    );
  }

  void _useDripped(DrippedIngredient ingredient, Emitter emit) =>
      emit(ingredient.mutation);

  @protected
  @override
  void drip(PipeContext context) {
    Potion? mutated = onDrip(context);

    if (mutated != null && mutated != state)
      add(
        DrippedIngredient(
          mutated,
        ),
      );
  }

  @protected
  Potion? onDrip(PipeContext context);

  T? lookup<T extends Flask>() => this is T ? this as T : null;
}
