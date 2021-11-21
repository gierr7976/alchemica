library explosion;

abstract class Explosion {
  final Object explosion;
  final StackTrace stackTrace;

  const Explosion({
    required this.explosion,
    required this.stackTrace,
  });
}

abstract class ExpectedExplosion extends Explosion {
  int get code;

  const ExpectedExplosion({
    required Object explosion,
    required StackTrace stackTrace,
  }) : super(
          explosion: explosion,
          stackTrace: stackTrace,
        );
}

class OccasionalExplosion extends Explosion {
  final int reportCode;

  const OccasionalExplosion({
    required this.reportCode,
    required Object explosion,
    required StackTrace stackTrace,
  }) : super(
          explosion: explosion,
          stackTrace: stackTrace,
        );
}
