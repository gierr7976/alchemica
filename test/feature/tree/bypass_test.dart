import 'package:alchemica/alchemica.dart';
import 'package:alchemica/debug.dart';
import 'package:flutter_test/flutter_test.dart';

class MarkedIngredient extends AlchemistIngredient {
  final int mark;

  MarkedIngredient(this.mark);

  @override
  MarkedIngredient copyWith({
    int? mark,
  }) =>
      MarkedIngredient(mark ?? this.mark);
}

class StrangeIngredient extends AlchemistIngredient {
  @override
  AlchemistIngredient copyWith() => StrangeIngredient();
}

class TestTrap extends Trap {
  TestTrap({
    Label? label,
    Pipe? child,
  }) : super(
          label: label,
          child: child,
        );

  @override
  void usages() {
    use<AlchemistIngredient>(onIngredient);
    use<PipeIngredient>(onIngredient);
    useDripped<Pipe, Potion>(onIngredient);
  }
}

class TestRecipeA extends Recipe {
  @override
  Pipe build() => BypassIn(label: Label(1));
}

class TestRecipeB extends Recipe {
  @override
  Pipe build() => BypassOut(
        label: Label(1),
        allowed: [BypassPerformer<MarkedIngredient>()],
        child: TestTrap(),
      );
}

class LoopedRecipe extends Recipe {
  @override
  Pipe build() => BypassOut(
        label: Label(1),
        allowed: [BypassPerformer<MarkedIngredient>()],
        child: TestTrap(
          child: BypassIn(label: Label(1)),
        ),
      );
}

void main() => group(
      'Logic tree bypassing tests',
      () {
        normal();
        dublicate();
        looped();
      },
    );

void normal() => test(
      'Normal bypassing test',
      () async {
        final BypassDispatcher dispatcher = BypassDispatcher();

        final Alchemist alchemistA = Alchemist(bypassDispatcher: dispatcher);
        alchemistA.buildFor(recipe: TestRecipeA());

        final Alchemist alchemistB = Alchemist(bypassDispatcher: dispatcher);
        alchemistB.buildFor(recipe: TestRecipeB());

        alchemistA.add(MarkedIngredient(1));
        alchemistA.add(StrangeIngredient());

        await Future(() => null);

        final List<Ingredient> caught =
            alchemistB.require<TestTrap>().require<BrewedTrap>().caught;

        expect(caught.length, 1);
        expect(caught.first is MarkedIngredient, true);
      },
    );

void dublicate() => test(
      'Dublicate bypassing test',
      () async {
        final BypassDispatcher dispatcher = BypassDispatcher();

        final Alchemist alchemistA = Alchemist(bypassDispatcher: dispatcher);
        alchemistA.buildFor(recipe: TestRecipeA());

        final Alchemist alchemistB = Alchemist(bypassDispatcher: dispatcher);
        alchemistB.buildFor(recipe: TestRecipeB());

        final MarkedIngredient ingredient = MarkedIngredient(1);
        alchemistA.add(ingredient);
        alchemistA.add(ingredient);
        alchemistA.add(MarkedIngredient(1));

        await Future(() => null);

        final List<Ingredient> caught =
            alchemistB.require<TestTrap>().require<BrewedTrap>().caught;

        expect(caught.length, 2);
        expect(
          caught.every((ingredient) => ingredient is MarkedIngredient),
          true,
        );
      },
    );

void looped() => group(
      'Looped bypassing tests',
      () {
        internal();
        external();
      },
    );

void internal() => test(
      'Internal injection test',
      () async {
        final Alchemist alchemist = Alchemist();
        alchemist.buildFor(recipe: LoopedRecipe());

        alchemist.require<BypassIn>(Label(1)).pass(MarkedIngredient(1));

        await Future(() => null);

        final List<Ingredient> caught =
            alchemist.require<TestTrap>().require<BrewedTrap>().caught;

        expect(caught.length, 1);
        expect(caught.first is MarkedIngredient, true);
      },
    );

void external() => test(
      'External injection test',
      () async {
        final Alchemist alchemist = Alchemist();
        alchemist.buildFor(recipe: LoopedRecipe());

        alchemist.add(MarkedIngredient(1));

        await Future(() => null);

        final List<Ingredient> caught =
            alchemist.require<TestTrap>().require<BrewedTrap>().caught;

        expect(caught.length, 1);
        expect(caught.first is MarkedIngredient, true);
      },
    );
