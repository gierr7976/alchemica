part of alchemica.consumers;

typedef LabExtractor<L extends LabState> = L Function(BuildContext context);

abstract class Crane<F extends Flask> extends StatelessWidget {
  static LabState _fallbackExtractor(BuildContext context) => Lab.of(context);

  final Label? label;

  final LabExtractor? extractor;

  @protected
  bool get strict => true;

  const Crane({
    Key? key,
    this.label,
    this.extractor,
  }) : super(key: key);

  F? getFlask(BuildContext context) {
    final LabState lab =
        extractor?.call(context) ?? _fallbackExtractor(context);

    if (strict) return lab.require(label);
    return lab.prefer(label);
  }

  Widget buildWithFlask(BuildContext context, F flask);

  Widget buildWithoutFlask(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final F? flask = getFlask(context);

    if (flask is F) return buildWithFlask(context, flask);
    return buildWithoutFlask(context);
  }
}
