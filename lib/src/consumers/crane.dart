part of alchemica.consumers;

abstract class Crane<F extends Flask> extends StatelessWidget {
  final Label? label;

  @protected
  bool get strict => true;

  const Crane({
    Key? key,
    this.label,
  }) : super(key: key);

  F? getFlask(BuildContext context) {
    final LabState lab = Lab.of(context);

    if (strict) return lab.require(label);
    return lab.prefer(label);
  }

  Widget buildWithFlask(BuildContext context, F flask);

  Widget buildWithoutFlask(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final F? flask = getFlask(context);

    if (flask is F)
      return buildWithFlask(context, flask);
    return buildWithoutFlask(context);
  }
}
