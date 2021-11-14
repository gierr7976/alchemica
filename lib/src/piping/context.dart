part of piping;

class PipeContext {
  final PipeContext? _nearestUpstreamContext;
  final Tap _currentTap;

  const PipeContext({
    required Tap currentTap,
    PipeContext? nearestUpstreamContext,
  })  : _nearestUpstreamContext = nearestUpstreamContext,
        _currentTap = currentTap;

  U lookup<U>() {
    if (_currentTap is U) return _currentTap as U;

    if (_nearestUpstreamContext == null) throw LookupError(U);

    return _nearestUpstreamContext!.lookup();
  }
}

class LookupError extends ArgumentError {
  LookupError(Type lookedUp)
      : super('There is no accessible $lookedUp in pipe system');
}
