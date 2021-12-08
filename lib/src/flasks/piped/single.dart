part of flasks;

abstract class SinglePipeFlask extends Flask {
  final Flask? child;
  StreamSubscription? _selfSubscription;

  SinglePipeFlask({this.child}) {
    _selfSubscription = stream.listen(_childDripper);
  }

  @override
  void dripper([PipeContext? nearestUpstreamContext]) {
    super.dripper(nearestUpstreamContext);

    _childDripper();
  }

  void _childDripper([Potion? update]) => child?.dripper(context);

  @override
  T? lookup<T extends Flask>() {
    if (this is T) return this as T;

    return child?.lookup();
  }

  @override
  Future<void> close() async {
    await _selfSubscription?.cancel();
    return super.close();
  }
}
