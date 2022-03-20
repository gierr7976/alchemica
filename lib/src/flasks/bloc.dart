part of alchemica.flasks;

typedef Magic<I extends Ingredient> = FutureOr<void> Function(
  I ingredient,
  Emitter<Potion> emit,
);

typedef MutationCallback = void Function(Potion potion);

class FlaskBloc extends Bloc<Ingredient, Potion> {
  @protected
  final MutationCallback onMutation;

  Fuse get fuse => GetIt.instance();

  StreamSubscription? _selfSubscription;

  FlaskBloc({
    required Potion initial,
    required this.onMutation,
  }) : super(initial);

  void use<I extends Ingredient>(
    Magic<I> magic,
    EventTransformer<I>? transformer,
  ) =>
      on<I>(
        (ingredient, emit) async {
          final PoisonedPotion? poisoned = await fuse.fuseAsync(
            () => magic(ingredient, emit),
          );

          if (poisoned is PoisonedPotion) emit(poisoned);
        },
        transformer: transformer,
      );

  @mustCallSuper
  void install() {
    _selfSubscription = stream.listen(onMutation);
  }

  @override
  Future<void> close() async {
    await _selfSubscription?.cancel();
    return super.close();
  }
}
