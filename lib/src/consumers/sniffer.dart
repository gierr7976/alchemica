part of consumers;

typedef SnifferFunction<P extends Potion> = void Function(
    BuildContext, P potion);

class Sniffer<F extends Flask, P extends Potion> extends StatelessWidget {
  final Widget child;
  final SnifferFunction sniffer;

  const Sniffer({
    Key? key,
    required this.child,
    required this.sniffer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocListener<F, Potion>(
        bloc: Lab.of(context).lookup(),
        listener: _listener,
        child: child,
      );

  void _listener(BuildContext context, Potion potion) {
    if (potion is P) sniffer(context, potion);
  }
}
