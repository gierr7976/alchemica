part of alchemica.consumers;

typedef PotionProcessorFunction<P extends Potion> = void Function(P potion);

class PotionProcessor<P extends Potion> {
  final PotionProcessorFunction<P> processor;

  PotionProcessor(this.processor);

  bool check(Potion potion) => potion is P;

  void call(P potion) => processor(potion);
}

class Indicator<F extends Flask> extends Crane<F> {
  final Widget child;
  final List<PotionProcessor> processors;

  @override
  final bool strict;

  const Indicator({
    Key? key,
    required this.child,
    this.strict = true,
    this.processors = const [],
  }) : super(key: key);

  @override
  Widget buildWithFlask(BuildContext context, F flask) =>
      BlocListener<FlaskBloc, Potion>(
        bloc: flask.bloc,
        listener: listener,
        child: child,
      );

  void listener(BuildContext context, Potion potion) {
    for (PotionProcessor processor in processors)
      if (processor.check(potion)) processor(potion);
  }

  @override
  Widget buildWithoutFlask(BuildContext context) => child;
}
