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

  void _selfListener(S state) {
    if (_latestContext is PipeContext && child is Pipe)
      child!.drip(_latestContext!.derivative(child!));
  }

  void onDispose() {
    // Intentionally left blank
  }

  @override
  Future<void> close() async {
    await _selfSubscription?.cancel();
    onDispose();
    return super.close();
  }

  //</editor-fold>

  //<editor-fold desc="Dripping methods">

  @override
  @mustCallSuper
  void drip(PipeContext context) {
    if (child is Pipe) child!.drip(context.derivative(child!));

    final S? dripped = onDrip(context);
    if (dripped is S) add(produceDripEvent(dripped));
  }

  E produceDripEvent(S dripped);

  S? onDrip(PipeContext context);

  //</editor-fold>

  @override
  T? find<T extends Pipe>([Label? label]) {
    final Label maybeThisLabel = label ?? this.label;

    if (this is T && this.label == maybeThisLabel) return this as T;

    return child?.find(label);
  }

  @override
  Map<Label, Pipe> extract() => {
        label: this,
        if (child is Pipe) ...child!.extract(),
      };
}
