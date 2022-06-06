part of alchemica.consumers;

@Deprecated('Use VialMixin or VialStateMixin instead')
abstract class Vial<P extends Potion?> extends StatelessWidget
    with VialMixin<P> {
  @override
  final P potion;

  const Vial({
    Key? key,
    required this.potion,
  }) : super(key: key);
}

mixin VialMixin<Contained extends Potion?> on Widget {
  Contained get potion;

  @protected
  LabState getLab(BuildContext context) => Lab.of(context);

  @protected
  void add(BuildContext context, AlchemistIngredient ingredient) =>
      getLab(context).add(ingredient);
}

mixin VialStateMixin<Contained extends Potion?> on State {
  Contained get potion;

  @protected
  LabState get lab => Lab.of(context);

  @protected
  void add(AlchemistIngredient ingredient) => lab.add(ingredient);
}
