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
        );

  @override
  DrippedIngredient produceDripEvent(Potion dripped) =>
      DrippedIngredient(dripped);

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
}
