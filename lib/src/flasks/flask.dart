part of alchemica.flasks;

typedef Magic<I extends Ingredient> = FutureOr<void> Function(
    I ingredient, Emitter emit);

abstract class Flask extends PipedBloc<Ingredient, Potion> {
  @protected
  final Fuse fuse = GetIt.instance();

  Flask({
    Label? label,
    Pipe? child,
    Potion? initialState,
  }) : super(
          initialState ?? UnderbrewedPotion(),
          label: label,
          child: child,
        ) {
    use<DrippedIngredient>(onDrippedIngredient);
  }

  @protected
  Future<void> onDrippedIngredient(
          DrippedIngredient ingredient, Emitter emit) async =>
      emit(ingredient.dripped);

  @override
  DrippedIngredient produceDripEvent(Potion dripped) =>
      DrippedIngredient(dripped);

  // TODO: add fusing unit test
  @protected
  void use<I extends Ingredient>(
    Magic<I> magic, [
    EventTransformer<I>? transformer,
  ]) {
    on<I>(
      (event, emit) async {
        Explosion? poisoner = await fuse.fuseAsync(
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

  @override
  @mustCallSuper
  Potion? onDrip(PipeContext context) {
    Flask? predecessor = context.predecessorWith(label);

    if (predecessor is Flask) return predecessor.state;
  }
}
