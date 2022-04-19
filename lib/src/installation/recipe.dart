part of alchemica.installation;

abstract class Recipe {
  List<AlchemistIngredient> get whenBuilt => [];

  Pipe build();
}
