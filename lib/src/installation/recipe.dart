part of alchemica.installation;

abstract class Recipe {
  List<AlchemistIngredient> get whenBuilt => [];

  Pipe build();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Recipe && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
