library fuses;

import 'dart:async';

import 'package:alchemica/src/explosions/explosion/explosion.dart';

/// Shorthand for executions that can be fused by [Fuse].
typedef Operation = void Function();

/// Shorthand for asynchronous executions that can be fused by [Fuse].
typedef AsyncOperation = FutureOr<void> Function();

/// Base class for computation fusing feature.
abstract class Fuse {
  /// Is fusing feature is enabled. When [false], failures won't be caught by
  /// [Fuse] making it accessible for debugger.
  final bool enabled;

  /// Default constructor.
  const Fuse(this.enabled);

  /// Fuses [operation] if [enabled] is [true].
  ///
  /// Returns [OccasionalExplosion] whenever some [Object] was thrown
  /// by [operation] or [null] if [operation] was completed successfully.
  ///
  /// If [enabled] is [false], always returns null or rethrows an [Object] from
  /// [operation].
  OccasionalExplosion? fuse(Operation operation) {
    try {
      operation();
      return null;
    } catch (e, s) {
      if (!enabled) rethrow;

      return OccasionalExplosion(
        explosion: e,
        stackTrace: s,
        reportCode: reportExplosion(e, s),
      );
    }
  }

  /// Fuses [operation] if [enabled] is [true].
  ///
  /// Returns [OccasionalExplosion] whenever some [Object] was thrown
  /// by [operation] or [null] if [operation] was completed successfully.
  ///
  /// If [enabled] is [false], always returns null or rethrows an [Object] from
  /// [operation].
  Future<OccasionalExplosion?> fuseAsync(AsyncOperation operation) async {
    try {
      await operation();
      return null;
    } catch (e, s) {
      if (!enabled) rethrow;

      return OccasionalExplosion(
        explosion: e,
        stackTrace: s,
        reportCode: reportExplosion(e, s),
      );
    }
  }

  /// Reports an [explosion] with [stackTrace].
  ///
  /// Shall return failure code provided by reporter.
  int reportExplosion(Object explosion, StackTrace stackTrace);
}
