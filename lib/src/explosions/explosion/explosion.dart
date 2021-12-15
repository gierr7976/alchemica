part of alchemica.explosions;

/// Base explosion class.
///
/// Any failures occurred during code execution within [alchemica] elements
/// should be wrapped by explosion.
///
/// This class does not meant to be extended outside [alchemica].
abstract class Explosion extends Error {
  /// Failure itself.
  final Object explosion;

  /// [StackTrace] within [explosion] occurred.
  final StackTrace stackTrace;

  /// Default constructor.
  Explosion({
    required this.explosion,
    required this.stackTrace,
  });
}

/// Base [Explosion] class for any normal failures expected by developer.
///
/// Feel free to extend this class to provide info about failure you expected.
///
/// Throwing an ExpectedExplosion is a good point to deal
/// with some expected problems, e.g deprecated app version.
abstract class ExpectedExplosion extends Explosion {
  /// Client designed code of explosion
  ///
  /// Use this to decide which actions should be performed when
  /// [ExpectedExplosion] given.
  int get code;

  /// Default constructor.
  ExpectedExplosion({
    required Object explosion,
    required StackTrace stackTrace,
  }) : super(
          explosion: explosion,
          stackTrace: stackTrace,
        );
}

/// Base [Explosion] class for any abnormal failures.
///
/// Meant to be constructed by [Fuse].
///
/// Shall not be extended outside [alchemica] package.
class OccasionalExplosion extends Explosion {
  /// Report code given by [Fuse].
  final int reportCode;

  /// Default constructor. Shall not be called outside [alchemica] package.
  OccasionalExplosion({
    required this.reportCode,
    required Object explosion,
    required StackTrace stackTrace,
  }) : super(
          explosion: explosion,
          stackTrace: stackTrace,
        );
}
