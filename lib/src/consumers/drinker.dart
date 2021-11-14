part of consumers;

typedef DrinkerBuilder<P extends Potion> = Widget Function(
    BuildContext context, P potion);

class Drinker<F extends Flask, P extends Potion> extends StatelessWidget {
  final DrinkerBuilder<P> drinker;

  const Drinker({
    Key? key,
    required this.drinker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<F, Potion>(
        bloc: Lab.of(context).lookup(),
        builder: _map,
      );

  Widget _map(BuildContext context, Potion potion) {
    if (potion is P) return drinker(context, potion);

    throw StateError('Incorrect potion: ${potion.runtimeType}');
  }
}
