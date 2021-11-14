part of piping;

mixin Tap {
  @protected
  void dripper([PipeContext? nearestUpstreamContext]) => drip(
        PipeContext(
          currentTap: this,
          nearestUpstreamContext: nearestUpstreamContext,
        ),
      );

  void drip(PipeContext context);
}
