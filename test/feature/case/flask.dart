part of 'case_test.dart';

class MockRecipe extends Recipe {
  final int? initial;

  MockRecipe([this.initial]);

  @override
  Pipe prepareLab() => MockFlask(initial: initial);
}

class MockFlask extends Flask {
  MockFlask({Label? label, int? initial})
      : super(
    label: label,
    initialState: initial is int ? BrewedMock(initial) : null,
  ) {
    use<IncIngredient>(onIncIngredient);
  }

  Future<void> onIncIngredient(IncIngredient ingredient, Emitter emit) async {
    if (ingredient.broken) throw ArgumentError('Intentionally broken');

    if (this.state is! BrewedMock) return;
    BrewedMock state = this.state as BrewedMock;

    emit(BrewedMock(state.value + 1));
  }
}

class IncIngredient extends AlchemistIngredient {
  final bool broken;

  const IncIngredient([this.broken = false]);
}

class BrewedMock extends BrewedPotion {
  final int value;

  const BrewedMock(this.value);

  @override
  String toString() => 'BrewedMock($value)';
}
