part of alchemica.piping;

/// Root element of logic tree.
///
/// Intended to be used as logic tree swapper.
/// Persists in the tree as shadowed root.
class RootPipe implements Pipe {
  @override
  Label get label =>
      throw UnimplementedError('Root pipe should not have labels');

  /// True root of current tree.
  Pipe? _child;

  /// Matches downstream elements with given condition.
  ///
  /// Returns first matching element. If no matches, [null] is returned.
  @override
  T? find<T extends Pipe>([Label? label]) => _child?.find(label);

  /// Extracts downstream element to preserve in
  /// tree mutation.
  @override
  Map<Label, Pipe> extract() => _child!.extract();

  /// Performs root swap with element preservation.
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
