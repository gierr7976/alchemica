part of alchemica.piping;

class RootPipe implements Pipe {
  @override
  Label get label =>
      throw UnimplementedError('Root pipe should not have labels');

  Pipe? _child;

  @override
  T? find<T extends Pipe>([Label? label]) => _child?.find(label);

  @override
  Map<Label, Pipe> extract() => _child!.extract();

  void updateChild(Pipe newChild) {
    Map<Label, Pipe>? oldTreeMap = _child?.extract();

    _child = newChild;
    _child!.drip(
      PipeContext._(
        current: newChild,
        predecessors: oldTreeMap,
      ),
    );
  }

  @override
  void drip(PipeContext context) =>
      throw UnimplementedError("Root pipe can't drip");

  @override
  void dispose() {
    _child?.dispose();
  }
}
