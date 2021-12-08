part of labs;

class _SinglePipeLabState extends LabState {
  Flask? piping;

  @override
  void buildPiping() {
    piping ??= widget.builder!();
    piping!.dripper(); // ignore: invalid_use_of_protected_member
  }

  @override
  T? _lookup<T extends Flask>() => piping!.lookup();
}
