part of alchemica.piping;

abstract class RootPipe extends Pipe {
  @override
  Label get label => Label.type(this);

  Pipe? _child;

  @override
  T? find<T extends Pipe>([Label? label]) => _child?.find(label);

  @override
  Map<Label, Pipe> extract() => _child!.extract();

  @protected
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
  void drip(PipeContext context) => UnimplementedError("Root pipe can't drip");
}
