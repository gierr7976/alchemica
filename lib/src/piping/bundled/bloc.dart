part of alchemica.piping;

abstract class PipedBloc<E, S> extends Bloc<E, S> implements Pipe {
  final Label? _label;
  final Pipe? child;

  StreamSubscription? _selfSubscription;
  PipeContext? _latestContext;

  @override
  Label get label => _label ?? Label.type(this);

  PipedBloc(
    S initialState, {
    Label? label,
    this.child,
  })  : _label = label,
        super(initialState) {
    onInit();
  }

  //<editor-fold desc="Lifecycle methods">

  @mustCallSuper
  void onInit() {
    _selfSubscription = stream.listen(_selfListener);
  }

  // TODO: add unit test
  void _selfListener(S state) {
    if (_latestContext is PipeContext && child is Pipe)
      child!.drip(_latestContext!._derivative(child!, dropPredecessors: true));
  }

  void onDispose() {
    // Intentionally left blank
  }

  @override
  void dispose() async {
    await close();
    onDispose();
  }

  @override
  Future<void> close() async {
    await _selfSubscription?.cancel();
    return super.close();
  }

  //</editor-fold>

  //<editor-fold desc="Dripping methods">

  @override
  @mustCallSuper
  void drip(PipeContext context) {
    _latestContext = context;
    if (child is Pipe) child!.drip(context._derivative(child!));

    final Bloc<E, S>? predecessor = context.predecessorWith(label);
    if (predecessor is Bloc<E, S>) add(produceDripEvent(predecessor.state));

    final S? dripped = onDrip(context);
    if (dripped is S) add(produceDripEvent(dripped));
  }

  E produceDripEvent(S dripped);

  S? onDrip(PipeContext context);

  //</editor-fold>

  @override
  T? find<T extends Pipe>([Label? label]) {
    final Label exactLabel = label ?? this.label;

    if (this is T && this.label == exactLabel) return this as T;

    return child?.find(label);
  }

  @override
  Map<Label, Pipe> extract() => {
        label: this,
        if (child is Pipe) ...child!.extract(),
      };
}
