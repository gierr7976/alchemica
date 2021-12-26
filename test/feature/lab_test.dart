import 'package:alchemica/alchemica.dart';
import 'package:alchemica/src/flasks/lib.dart';
import 'package:alchemica/src/labs/lib.dart';
import 'package:alchemica/src/piping/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() => group(
      'Lab feature tests',
      () {
        setUpAll(set);
        init();
        fork();
        mutation();
      },
    );

//<editor-fold desc="Mock classes">

class MockFlaskA extends Flask {
  // Intentionally left blank
}

class MockFlaskB extends Flask {
  // Intentionally left blank
}

class MockFlaskC extends Flask {
  MockFlaskC([Pipe? child]) : super(child: child);
}

class BrewedMock extends BrewedPotion {
  final int value;

  const BrewedMock(this.value);
}

class MockFuse extends Fuse {
  MockFuse() : super(false);

  @override
  int reportExplosion(Object explosion, StackTrace stackTrace) => -42;
}

class RecipeA extends Recipe {
  @override
  Pipe prepareLab() => MockFlaskA();
}

class RecipeFork extends Recipe {
  @override
  Pipe prepareLab() => Fork(
        children: [
          MockFlaskA(),
          MockFlaskB(),
        ],
      );
}

class RecipeB extends Recipe {
  @override
  Pipe prepareLab() => MockFlaskC(
        MockFlaskA(),
      );
}

//</editor-fold>

void set() {
  GetIt.instance.registerFactory<Fuse>(() => MockFuse());
}

void init() => testWidgets(
      'Initialization test',
      (tester) async {
        await tester.pumpWidget(
          Lab(
            recipe: RecipeA(),
            child: SizedBox(),
          ),
        );

        LabState lab = tester.state(find.byType(Lab));

        MockFlaskA? flask = lab.find<RecipeA, MockFlaskA>();

        expect(flask, isNotNull);
      },
    );

void fork() => testWidgets(
      'Forking test',
      (tester) async {
        await tester.pumpWidget(
          Lab(
            recipe: RecipeFork(),
            child: SizedBox(),
          ),
        );

        LabState lab = tester.state(find.byType(Lab));

        MockFlaskA? flaskA = lab.find<RecipeFork, MockFlaskA>();
        expect(flaskA, isNotNull);

        MockFlaskB? flaskB = lab.find<RecipeFork, MockFlaskB>();
        expect(flaskB, isNotNull);
      },
    );

void mutation() => testWidgets(
      'Mutation test',
      (tester) async {
        await tester.pumpWidget(
          Lab(
            recipe: RecipeA(),
            child: SizedBox(),
          ),
        );

        LabState lab = tester.state(find.byType(Lab));

        MockFlaskA? flaskA = lab.find<RecipeA, MockFlaskA>();
        expect(flaskA, isNotNull);

        flaskA!.add(DrippedIngredient(BrewedMock(2)));

        await tester.pump();

        lab.prepare(RecipeB());

        await tester.pump();

        flaskA = lab.find<RecipeB, MockFlaskA>();
        expect(flaskA, isNotNull);
        expect(flaskA!.state is BrewedMock, true);
        BrewedMock potion = flaskA.state as BrewedMock;
        expect(potion.value, 2);
      },
    );
