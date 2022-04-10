part of alchemica.debug.trap;

class Trap extends ConnectedFlask {
  Trap({
    Label? label,
    Pipe? child,
  }) : super(
          label: label,
          child: child,
        );

  @protected
  Future<void> onIngredient(Ingredient ingredient, Emitter emit) async {
    final BrewedTrap? old = prefer();

    emit(
      BrewedTrap(
        caught: [
          ...(old?.caught ?? []),
          ingredient,
        ],
      ),
    );
  }

  @override
  void onMutation(Potion potion) {
    // Intentionally left blank
  }
}
