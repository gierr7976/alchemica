part of alchemica.consumers;

class Pourer<F extends Flask> extends Crane<F> {
  final WidgetBuilder? onMissing;
  final Rule rule;

  @override
  bool get strict => onMissing == null;

  const Pourer({
    Key? key,
    Label? label,
    required this.rule,
    this.onMissing,
    LabExtractor? extractor,
  }) : super(
          key: key,
          label: label,
          extractor: extractor,
        );

  @override
  Widget buildWithFlask(BuildContext context, F flask) =>
      BlocBuilder<FlaskBloc, Potion>(
        bloc: getFlask(context)!.bloc,
        builder: rule.map,
      );

  @override
  Widget buildWithoutFlask(BuildContext context) => onMissing!(context);
}
