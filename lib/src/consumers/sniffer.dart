part of consumers;

typedef SnifferFunction<P extends Potion> = void Function(
    BuildContext, P potion);

class Sniffer<F extends Flask, P extends Potion> extends StatelessWidget {
  final Widget child;
  final SnifferFunction<P> sniffer;
  final BlocBuilderCondition<P>? sniffWhen;

  const Sniffer({
    Key? key,
    required this.child,
    required this.sniffer,
    this.sniffWhen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocListener<F, Potion>(
        bloc: Lab.of(context).lookup(),
        listener: (context, potion) => sniffer(context, potion as P),
        listenWhen: _listenWhen,
        child: child,
      );

  bool _listenWhen(Potion previous, Potion current) {
    if (current is! P)
      throw StateError('Incorrect potion: ${current.runtimeType}');
    if (sniffWhen == null) return true;
    if (previous is! P) return true;

    return sniffWhen!(previous, current);
  }
}
