part of flasks;

abstract class MultiChildFlask extends Flask {
  final List<Flask> children;

  MultiChildFlask({required this.children});

  @override
  void dripper([PipeContext? nearestUpstreamContext]) {
    super.dripper(nearestUpstreamContext);

    _childrenDripper();
  }

  @override
  void onChange(Change<Potion> change) {
    super.onChange(change);

    _childrenDripper();
  }

  void _childrenDripper() {
    for (Flask flask in children) flask.dripper(context);
  }
}
