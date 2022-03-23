part of alchemica.consumers;

class Pourer<F extends Flask> extends StatelessWidget {
  final Label? label;
  final WidgetBuilder? onMissing;
  final Rule rule;

  @protected
  bool get strict => onMissing == null;

  F? getFlask(BuildContext context) {
    final LabState lab = Lab.of(context);

    if (strict) return lab.require(label);
    return lab.prefer(label);
  }

  const Pourer({
    Key? key,
    this.label,
    required this.rule,
    this.onMissing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final F? flask = getFlask(context);

    if (flask is F)
      return BlocBuilder<FlaskBloc, Potion>(
        bloc: getFlask(context)!.bloc,
        builder: rule.map,
      );

    return onMissing!(context);
  }
}
