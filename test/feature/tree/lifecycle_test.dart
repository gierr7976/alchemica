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

void main() => group(
      'Logic tree feature tests',
      () {
        presence();
      },
    );

void presence() => test(
      'Presence test',
      () {
        final Pipe root = TestRecipe().build();

        final BypassIn? bypassIn = root.find();
        final BypassOut? bypassOut = root.find();
        final TestFlask? flaskA = root.find(Label(1));
        final TestFlask? flaskB = root.find(Label(2));
        final Fork? fork = root.find();

        expect(bypassIn is BypassIn, true);
        expect(bypassOut is BypassOut, true);
        expect(flaskA is TestFlask, true);
        expect(flaskB is TestFlask, true);
        expect(identical(flaskA, flaskB), false);
        expect(fork is Fork, true);
      },
    );
