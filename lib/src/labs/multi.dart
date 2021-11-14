part of labs;

class _MultiPipeLabState extends LabState {
  List<Flask>? piping;

  @override
  void buildPiping() {
    piping ??= widget.multiBuilder!();
  }

  @override
  T? _lookup<T extends Flask>() {
    for (Flask flask in piping!) {
      T? fromFlask = flask.lookup();
      if (fromFlask != null) return fromFlask;
    }
  }
}
