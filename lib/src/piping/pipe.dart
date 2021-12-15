part of alchemica.piping;

/// Logic tree element interface.
///
/// Contains all general behaviors of element meant to be used as part of
/// logic tree.
abstract class Pipe {
  /// Returns label of element.
  ///
  /// Used for matching elements preserved in tree mutation.
  Label get label;

  /// Handles upstream logic tree events.
  @protected
  void drip(PipeContext context);

  /// Matches itself and downstream elements with given condition.
  ///
  /// Returns first matching element.
  T? find<T extends Pipe>([Label? label]);

  /// Extracts downstream element and itself (if intended) to preserve in
  /// tree mutation.
  @protected
  Map<Label, Pipe> extract();

  /// Handles disposing of logic tree.
  void dispose();
}
