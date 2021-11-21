part of piping;

/// Base piping class allowing to handle upstream updates.
mixin Tap {
  PipeContext? _context;

  /// Last dripped context.
  ///
  /// <br>
  /// _Throws an error when accessed before first drip._
  PipeContext get context => _context!;

  /// Performs actions needed to notify current [Tap] instance that there are
  /// some upstream updates.
  ///
  /// <br>
  /// [nearestUpstreamContext] — [PipeContext] of upstream [Tap] instance that
  /// called this method.
  ///
  /// [Tap] instance should call this method on its children whenever
  /// it updates.
  @protected
  void dripper([PipeContext? nearestUpstreamContext]) {
    _context = PipeContext._(
      currentTap: this,
      nearestUpstreamContext: nearestUpstreamContext,
    );

    drip(_context!);
  }

  /// Performs actions to handle upstream updates.
  void drip(PipeContext context);
}
