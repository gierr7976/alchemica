part of flasks;

abstract class MultiPipeFlask extends Flask {
  final List<Flask> children;
  StreamSubscription? _selfSubscription;

  MultiPipeFlask({this.children = const []}) {
    _selfSubscription = stream.listen(_childrenDripper);
  }

  @override
  void dripper([PipeContext? nearestUpstreamContext]) {
    super.dripper(nearestUpstreamContext);

    _childrenDripper();
  }

  void _childrenDripper([Potion? update]) {
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

  @override
  Future<void> close() async {
    await _selfSubscription?.cancel();
    return super.close();
  }
}
