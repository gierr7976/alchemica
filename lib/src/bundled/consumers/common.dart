part of alchemica.bundled.consumers;

typedef PotionWidgetBuilder<P extends Potion?> = Widget Function(
  BuildContext context,
  P potion,
);

typedef VialBuilder<P extends Potion?> = Vial<P> Function(
  BuildContext context,
  P potion,
);
