part of 'alchemist_test.dart';

class CounterFlask extends Flask {
  CounterFlask() {
    use<ValueIngredient>(onValueIngredient);
  }

  @override
  Potion? onDrip(PipeContext context) => null;

  @protected
  Future<void> onValueIngredient(
      ValueIngredient ingredient, Emitter emit) async {
    emit(
      CounterPotion(
        ingredient.value,
      ),
    );
  }
}

class CounterPotion extends BrewedPotion {
  final int value;

  const CounterPotion(this.value);
}

class ValueIngredient extends FinalIngredient {
  final int value;

  const ValueIngredient([this.value = 0]);

  @override
  String toString() {
    return 'ValueIngredient{value: $value}';
  }
}
