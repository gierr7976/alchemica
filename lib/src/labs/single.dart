part of labs;

class _SinglePipeLabState extends LabState {
  Flask? piping;

  @override
  void buildPiping() {
    piping ??= widget.builder!();
  }
}
