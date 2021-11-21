part of piping;

/// Class contains useful information on [Tap]'s upstream surrounding.
class PipeContext {
  final PipeContext? _nearestUpstreamContext;
  final Tap _currentTap;

  /// Default constructor.
  ///
  /// Does not meant to be used outside [piping] library.
  const PipeContext({
    required Tap currentTap,
    PipeContext? nearestUpstreamContext,
  })  : _nearestUpstreamContext = nearestUpstreamContext,
        _currentTap = currentTap;

  /// Looks up for [Tap] type of [U] in piping tree.
  ///
  /// Returns nearest instance of [U] if contained in piping.
  ///
  /// Throws a [LookupError] in other cases.
  U lookup<U>() {
    if (_currentTap is U) return _currentTap as U;

    if (_nearestUpstreamContext == null) throw LookupError(U);

    return _nearestUpstreamContext!.lookup();
  }
}

/// Error class for lookup fails.
class LookupError extends ArgumentError {
  /// Default constructor.
  ///
  /// [lookedUp] — type being looked up.
  LookupError(Type lookedUp)
      : super('There is no accessible $lookedUp in piping system');
}
