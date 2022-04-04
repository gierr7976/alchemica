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

class TestRecipeDump {
  final BypassIn? bypassIn;
  final BypassOut? bypassOut;
  final TestFlask? flaskA;
  final TestFlask? flaskB;
  final Fork? fork;

  const TestRecipeDump({
    this.bypassIn,
    this.bypassOut,
    this.flaskA,
    this.flaskB,
    this.fork,
  });

  factory TestRecipeDump.from(Pipe pipe) => TestRecipeDump(
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

        final TestRecipeDump dump = TestRecipeDump.from(root);

        expect(dump.bypassIn is BypassIn, true);
        expect(dump.bypassOut is BypassOut, true);
        expect(dump.flaskA is TestFlask, true);
        expect(dump.flaskB is TestFlask, true);
        expect(identical(dump.flaskA, dump.flaskB), false);
        expect(dump.fork is Fork, true);
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

        final TestRecipeDump dump = TestRecipeDump.from(root);

        expect(dump.flaskA!.isInstalled, true);
        expect(dump.flaskB!.isInstalled, true);
        expect(dump.bypassIn!.isInstalled, true);
        expect(dump.bypassOut!.isInstalled, true);
      },
    );
