part of alchemica.bundled.consumers;

// ignore_for_file: deprecated_member_use_from_same_package

typedef PotionWidgetBuilder<P extends Potion?> = Widget Function(
  BuildContext context,
  P potion,
);

@Deprecated('Use PotionWidgetBuilder instead')
typedef VialBuilder<P extends Potion?> = Vial<P> Function(
  BuildContext context,
  P potion,
);
