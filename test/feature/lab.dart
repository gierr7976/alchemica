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
      },
    );

//<editor-fold desc="Mock classes">

class MockFlaskA extends Flask {
  @override
  Potion? onDrip(PipeContext context) => null;
}

class MockFlaskB extends Flask {
  @override
  Potion? onDrip(PipeContext context) => null;
}

class MockFlaskC extends Flask {
  @override
  Potion? onDrip(PipeContext context) => null;
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

class RecipeInit extends Recipe {
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

//</editor-fold>

void set() {
  GetIt.instance.registerFactory<Fuse>(() => MockFuse());
}

void init() => testWidgets(
      'Initialization test',
      (tester) async {
        await tester.pumpWidget(
          Lab(
            recipe: RecipeInit(),
            child: SizedBox(),
          ),
        );

        LabState lab = tester.state(find.byType(Lab));

        MockFlaskA? flask = lab.find<RecipeInit, MockFlaskA>();

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
