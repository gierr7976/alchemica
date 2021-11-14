library fuses;

import 'dart:async';

import 'package:alchemica/src/explosions/explosion/explosion.dart';

typedef Operation = void Function();
typedef AsyncOperation = FutureOr<void> Function();

abstract class Fuse {
  final bool enabled;

  const Fuse(this.enabled);

  OccasionalExplosion? fuse(Operation operation) {
    if (!enabled) {
      operation();
      return null;
    }

    try {
      operation();
      return null;
    } catch (e, s) {
      return OccasionalExplosion(
        explosion: e,
        stackTrace: s,
        reportCode: reportExplosion(e, s),
      );
    }
  }

  Future<OccasionalExplosion?> fuseAsync(AsyncOperation operation) async {
    if (!enabled) {
      await operation();
      return null;
    }

    try {
      await operation();
      return null;
    } catch (e, s) {
      return OccasionalExplosion(
        explosion: e,
        stackTrace: s,
        reportCode: reportExplosion(e, s),
      );
    }
  }

  int reportExplosion(Object explosion, StackTrace stackTrace);
}
