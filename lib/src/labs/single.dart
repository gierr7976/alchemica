part of labs;

class _SinglePipeLabState extends LabState {
  Flask? piping;

  @override
  void buildPiping() {
    piping ??= widget.builder!();
  }

  @override
  T? _lookup<T extends Flask>() => piping!.lookup();
}
