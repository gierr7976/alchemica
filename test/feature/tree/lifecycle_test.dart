import 'package:alchemica/alchemica.dart';
import 'package:alchemica/debug.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

class MarkedIngredient extends AlchemistIngredient {
  final int? marker;

  const MarkedIngredient({
    this.marker,
  });

  @override
  MarkedIngredient copyWith({
    int? marker,
  }) =>
      MarkedIngredient(
        marker: marker ?? this.marker,
      );

  @override
  String toString() => 'MarkedIngredient($marker)';
}

class TestFlask extends ConnectedFlask {
  TestFlask({
    Label? label,
    Pipe? child,
  }) : super(label: label, child: child);

  @override
  void usages() {
    use<MarkedIngredient>(onMarkedIngredient);
  }

  @protected
  Future<void> onMarkedIngredient(
    MarkedIngredient ingredient,
    Emitter emit,
  ) async =>
      emit(
        MarkedPotion(
          marker: ingredient.marker,
        ),
      );
}

class MarkedPotion extends BrewedPotion {
  final int? marker;

  const MarkedPotion({
    this.marker,
  });

  @override
  MarkedPotion copyWith({
    int? marker,
  }) =>
      MarkedPotion(
        marker: marker ?? this.marker,
      );

  @override
  String toString() => 'MarkedPotion($marker)';
}

class TestTrap extends Trap {
  @override
  void usages() {
    use<AlchemistIngredient>(onIngredient);
    use<PipeIngredient>(onIngredient);
    useDripped<Pipe, Potion>(onIngredient);
  }
}

class TestRecipe extends Recipe {
  TestRecipe();

  @override
  Pipe build() => BypassOut(
        label: Label(1),
        allowed: [],
        child: TestFlask(
          label: Label(1),
          child: Fork(
            children: [
              BypassIn(
                label: Label(1),
              ),
              TestFlask(
                label: Label(2),
                child: TestTrap(),
              )
            ],
          ),
        ),
      );
}

class TestRecipeSnapshot {
  final BypassIn? bypassIn;
  final BypassOut? bypassOut;
  final TestFlask? flaskA;
  final TestFlask? flaskB;
  final Fork? fork;
  final TestTrap? trap;

  const TestRecipeSnapshot({
    this.bypassIn,
    this.bypassOut,
    this.flaskA,
    this.flaskB,
    this.fork,
    this.trap,
  });

  factory TestRecipeSnapshot.from(Pipe pipe) => TestRecipeSnapshot(
        bypassIn: pipe.find(),
        bypassOut: pipe.find(),
        flaskA: pipe.find(Label(1)),
        flaskB: pipe.find(Label(2)),
        fork: pipe.find(),
        trap: pipe.find(),
      );
}

void main() => group(
      'Logic tree lifecycle tests',
      () {
        presence();
        installation();
        uninstallation();
        processing();
        collection();
        preservation();
      },
    );

void presence() => test(
      'Presence test',
      () {
        final Pipe root = TestRecipe().build();

        final TestRecipeSnapshot snapshot = TestRecipeSnapshot.from(root);

        expect(snapshot.bypassIn is BypassIn, true);
        expect(snapshot.bypassOut is BypassOut, true);
        expect(snapshot.flaskA is TestFlask, true);
        expect(snapshot.flaskB is TestFlask, true);
        expect(identical(snapshot.flaskA, snapshot.flaskB), false);
        expect(snapshot.fork is Fork, true);
        expect(snapshot.trap is TestTrap, true);
      },
    );

void installation() => test(
      'Installation test',
      () {
        final Alchemist alchemist = Alchemist();
        alchemist.build(recipe: TestRecipe());

        final TestRecipeSnapshot snapshot = TestRecipeSnapshot.from(
          alchemist.root,
        );

        expect(snapshot.flaskA!.isInstalled, true);
        expect(snapshot.flaskB!.isInstalled, true);
        expect(snapshot.bypassIn!.isInstalled, true);
        expect(snapshot.bypassOut!.isInstalled, true);
        expect(snapshot.trap!.isInstalled, true);
      },
    );

void uninstallation() => test(
      'Uninstallation test',
      () {
        final Alchemist alchemist = Alchemist();
        alchemist.build(recipe: TestRecipe());

        final TestRecipeSnapshot snapshot = TestRecipeSnapshot.from(
          alchemist.root,
        );

        alchemist.uninstall();

        expect(snapshot.flaskA!.isInstalled, false);
        expect(snapshot.flaskB!.isInstalled, false);
        expect(snapshot.bypassIn!.isInstalled, false);
        expect(snapshot.bypassOut!.isInstalled, false);
        expect(snapshot.trap!.isInstalled, false);
      },
    );

void processing() => test(
      'Ingredient processing test',
      () async {
        final Alchemist alchemist = Alchemist();
        alchemist.build(recipe: TestRecipe());

        alchemist.add(MarkedIngredient(marker: 2));

        await Future(() => null);

        final List<Ingredient> fromTrap =
            alchemist.prefer<TestTrap>()?.prefer<BrewedTrap>()?.caught ?? [];

        expect(fromTrap.length, 3);

        final bool hasMarked =
            fromTrap.any((element) => element is MarkedIngredient);
        final int drippedCount = fromTrap.whereType<DrippedIngredient>().length;

        expect(hasMarked, true);
        expect(drippedCount, 2);
      },
    );

void collection() => test(
      'Collection test',
      () async {
        final Alchemist alchemist = Alchemist();
        alchemist.build(recipe: TestRecipe());

        alchemist.add(MarkedIngredient(marker: 2));

        await Future(() => null);

        Map<Label, Potion> collection = alchemist.root.collect();

        expect(collection[Label(1)] is MarkedPotion, true);
        expect(collection[Label(2)] is MarkedPotion, true);
        expect(collection[Label(TestTrap)] is BrewedTrap, true);
        expect(collection.length, 3);
      },
    );

void preservation() => test(
      'Preservation test',
      () async {
        final Alchemist alchemist = Alchemist();
        alchemist.build(recipe: TestRecipe());

        alchemist.add(MarkedIngredient(marker: 2));

        final Pipe oldRoot = alchemist.root;

        await Future(() => null);

        alchemist.build(recipe: TestRecipe());

        final Map<Label, Potion> collection = alchemist.root.collect();

        expect(identical(alchemist.root, oldRoot), false);
        expect(collection[Label(1)] is MarkedPotion, true);
        expect(collection[Label(2)] is MarkedPotion, true);
        expect(collection[Label(TestTrap)] is BrewedTrap, true);
        expect(collection.length, 3);
      },
    );
