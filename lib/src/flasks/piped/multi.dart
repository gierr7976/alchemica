part of flasks;

abstract class MultiPipeFlask extends Flask {
  final List<Flask> children;

  MultiPipeFlask({this.children = const []});

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

  @override
  T? lookup<T extends Flask>() {
    if (this is T) return this as T;

    for (Flask flask in children) {
      T? inChildren = flask.lookup();
      if (inChildren != null) return inChildren;
    }
  }
}
