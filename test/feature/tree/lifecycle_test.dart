import 'package:alchemica/alchemica.dart';
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
}

class TestFlask extends ConnectedFlask {
  TestFlask({
    Label? label,
    Pipe? child,
  }) : super(label: label, child: child);

  @override
  void usages() {
    super.usages();

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
}

class Trap extends Pipe {
  final Label? _label;

  @override
  Label get label => _label ?? super.label;

  final Pipe? child;
  final void Function(Ingredient ingredient) onCaught;

  Trap({
    Label? label,
    this.child,
    required this.onCaught,
  }) : _label = label;

  @override
  void install(PipeContext context) {
    child?.install(
      context.inherit(child!),
    );
  }

  @override
  void pass(Ingredient ingredient) {
    onCaught(ingredient);
    child?.pass(ingredient);
  }

  @override
  void uninstall() {
    child?.uninstall();
  }
}

class TestRecipe extends Recipe {
  final void Function(Ingredient ingredient) onCaught;

  TestRecipe(this.onCaught);

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
                child: Trap(
                  onCaught: onCaught,
                ),
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

  const TestRecipeSnapshot({
    this.bypassIn,
    this.bypassOut,
    this.flaskA,
    this.flaskB,
    this.fork,
  });

  factory TestRecipeSnapshot.from(Pipe pipe) => TestRecipeSnapshot(
        bypassIn: pipe.find(),
        bypassOut: pipe.find(),
        flaskA: pipe.find(Label(1)),
        flaskB: pipe.find(Label(2)),
        fork: pipe.find(),
      );
}

void main() => group(
      'Logic tree feature tests',
      () {
        presence();
        installation();
        processing();
      },
    );

void presence() => test(
      'Presence test',
      () {
        final Pipe root = TestRecipe((_) => _).build();

        final TestRecipeSnapshot snapshot = TestRecipeSnapshot.from(root);

        expect(snapshot.bypassIn is BypassIn, true);
        expect(snapshot.bypassOut is BypassOut, true);
        expect(snapshot.flaskA is TestFlask, true);
        expect(snapshot.flaskB is TestFlask, true);
        expect(identical(snapshot.flaskA, snapshot.flaskB), false);
        expect(snapshot.fork is Fork, true);
      },
    );

void installation() => test(
      'Installation test',
      () {
        final Pipe root = TestRecipe((_) => _).build();
        root.install(
          PipeContext(
            current: root,
            bypassDispatcher: BypassDispatcher(),
            fuseDispatcher: FuseDispatcher(),
          ),
        );

        final TestRecipeSnapshot snapshot = TestRecipeSnapshot.from(root);

        expect(snapshot.flaskA!.isInstalled, true);
        expect(snapshot.flaskB!.isInstalled, true);
        expect(snapshot.bypassIn!.isInstalled, true);
        expect(snapshot.bypassOut!.isInstalled, true);
      },
    );

void processing() => test(
      'Ingredient processing test',
      () async {
        final List<Ingredient> fromTrap = [];

        final Pipe root = TestRecipe(
          (ingredient) => fromTrap.add(ingredient),
        ).build();
        root.install(
          PipeContext(
            current: root,
            bypassDispatcher: BypassDispatcher(),
            fuseDispatcher: FuseDispatcher(),
          ),
        );

        root.pass(MarkedIngredient(marker: 2));

        await Future.delayed(Duration(milliseconds: 10));

        expect(fromTrap.length, 3);

        final bool hasMarked =
            fromTrap.any((element) => element is MarkedIngredient);
        final int drippedCount = fromTrap.whereType<DrippedIngredient>().length;

        expect(hasMarked, true);
        expect(drippedCount, 2);
      },
    );
