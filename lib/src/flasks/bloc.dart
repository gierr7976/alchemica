part of alchemica.flasks;

typedef Magic<I extends Ingredient> = FutureOr<void> Function(
  I ingredient,
  Emitter<Potion> emitter,
);

typedef MutationCallback = void Function(Potion potion);

class FlaskBloc extends Bloc<Ingredient, Potion> {
  @protected
  final MutationCallback onMutation;

  StreamSubscription? _selfSubscription;

  FlaskBloc({
    required Potion initial,
    required this.onMutation,
  }) : super(initial);

  void use<I extends Ingredient>(
    Magic<I> magic,
    EventTransformer<I>? transformer,
  ) {
    // TODO: add fusing
    on<I>(magic, transformer: transformer);
  }

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
