part of alchemica.flasks;

class DrippedIngredient<Dripper extends Pipe, Dripped extends Potion>
    extends PipeIngredient {
  final Dripper dripper;
  final Dripped potion;

  const DrippedIngredient({
    required this.dripper,
    required this.potion,
  });

  @override
  DrippedIngredient copyWith({
    Dripper? dripper,
    Dripped? potion,
  }) =>
      DrippedIngredient(
        dripper: dripper ?? this.dripper,
        potion: potion ?? this.potion,
      );
}
