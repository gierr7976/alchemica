part of piping;

mixin Tap {
  PipeContext? _context;

  PipeContext get context => _context!;

  @protected
  void dripper([PipeContext? nearestUpstreamContext]) {
    _context = PipeContext(
      currentTap: this,
      nearestUpstreamContext: nearestUpstreamContext,
    );

    drip(_context!);
  }

  void drip(PipeContext context);
}
