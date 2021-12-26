import 'package:alchemica/alchemica.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class MockFuse extends Fuse {
  static void inject() => GetIt.instance.registerSingleton<Fuse>(
        MockFuse(true),
      );

  Logger logger = Logger();

  MockFuse(bool enabled) : super(enabled);

  @override
  int reportExplosion(Object explosion, StackTrace stackTrace) {
    logger.e('Explosion fused', explosion, stackTrace);

    return -42;
  }
}
