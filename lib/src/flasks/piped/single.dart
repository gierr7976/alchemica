part of flasks;

abstract class SinglePipeFlask extends Flask {
  final Flask child;

  SinglePipeFlask({required this.child});

  @override
  void dripper([PipeContext? nearestUpstreamContext]) {
    super.dripper(nearestUpstreamContext);

    _childDripper();
  }

  @override
  void onChange(Change<Potion> change) {
    super.onChange(change);

    _childDripper();
  }

  void _childDripper() => child.dripper(context);
}
