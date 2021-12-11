part of alchemica.consumers;

class PotionAlarm<R extends Recipe, F extends Flask> extends StatelessWidget
    with FlaskExtractor<R, F> {
  @override
  final Label? label;
  final AlchemicaAlarm alarm;
  final AlchemicaCondition? alarmWhen;
  final Widget child;

  const PotionAlarm({
    Key? key,
    this.label,
    required this.alarm,
    required this.child,
    this.alarmWhen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocListener<F, Potion>(
        bloc: extractFlask(context),
        listenWhen: alarmWhen,
        listener: alarm,
        child: child,
      );
}
