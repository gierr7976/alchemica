part of alchemica.bundled.consumers;

typedef PotionWidgetBuilder<P extends Potion?> = Widget Function(
  BuildContext context,
  P potion,
);

typedef VialBuilder<P extends Potion?> = Vial<Potion> Function(
  BuildContext context,
  P potion,
);
