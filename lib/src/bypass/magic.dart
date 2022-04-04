part of alchemica.bypass;

FutureOr<void> _voidMagic(_, __) => null;

class BypassPerformer<I extends Ingredient> extends MagicPerformer<I> {
  BypassPerformer() : super(_voidMagic);
}

class DrippedBypassPerformer<D extends Pipe, P extends Potion>
    extends DrippedMagicPerformer<D, P> {
  DrippedBypassPerformer() : super(_voidMagic);
}
