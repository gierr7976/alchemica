part of alchemica.consumers;

mixin FlaskExtractor<R extends Recipe, F extends Flask> {
  Label? get label;

  @protected
  F extractFlask(BuildContext context) {
    F? flask = Lab.of(context).find<R, F>(label);

    if (flask is F) return flask;
    throw ArgumentError('There is no suitable flask: $F');
  }
}
