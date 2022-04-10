part of alchemica.preparations;

abstract class Ingredient implements Prototype {
  const Ingredient();

  @override
  Ingredient copyWith();

  @override
  String toString() => runtimeType.toString();
}

abstract class AlchemistIngredient extends Ingredient {
  const AlchemistIngredient();

  @override
  AlchemistIngredient copyWith();
}

abstract class PipeIngredient extends Ingredient {
  const PipeIngredient();

  @override
  PipeIngredient copyWith();
}

class DrippedIngredient extends Ingredient {
  final Pipe _dripper;
  final Potion _potion;

  const DrippedIngredient({
    required Pipe dripper,
    required Potion potion,
  })  : _dripper = dripper,
        _potion = potion;

  P extract<P extends Potion>() {
    if (_potion is! P) throw ArgumentError('Incompatible potion!');

    return _potion as P;
  }

  @override
  DrippedIngredient copyWith({
    Pipe? dripper,
    Potion? potion,
  }) =>
      DrippedIngredient(
        dripper: dripper ?? _dripper,
        potion: potion ?? _potion,
      );
}
