part of labs;

class _MultiPipeLabState extends LabState {
  List<Flask>? piping;

  @override
  void buildPiping() {
    piping ??= widget.multiBuilder!();
  }
}
