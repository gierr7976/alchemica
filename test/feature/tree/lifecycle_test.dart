import 'package:alchemica/alchemica.dart';
import 'package:flutter_test/flutter_test.dart';

class TestFlask extends ConnectedFlask {
  TestFlask({
    Label? label,
    Pipe? child,
  }) : super(label: label, child: child);
}

class TestRecipe extends Recipe {
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
      },
    );

void installation() => test(
      'Installation test',
      () {
        final Pipe root = TestRecipe().build();
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
