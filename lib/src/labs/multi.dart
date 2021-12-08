part of labs;

class _MultiPipeLabState extends LabState {
  List<Flask>? piping;

  @override
  void buildPiping() {
    piping ??= widget.multiBuilder!();
    for (Flask flask in piping!)
      flask.dripper(); // ignore: invalid_use_of_protected_member
  }

  @override
  T? _lookup<T extends Flask>() {
    for (Flask flask in piping!) {
      T? fromFlask = flask.lookup();
      if (fromFlask != null) return fromFlask;
    }
  }
}
