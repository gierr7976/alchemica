import 'package:alchemica/alchemica.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

part 'flask.dart';
part 'widget.dart';

void main() {
  GetIt.instance.registerFactory<Fuse>(() => MockFuse());
  group(
    'Alchemist tests',
    () {
      init();
      update();
    },
  );
}

void init() => testWidgets(
      'Alchemist initialization test',
      (WidgetTester tester) async {
        await tester.pumpWidget(Counter());

        final loadingFinder = find.text('LOADING');

        expect(loadingFinder, findsOneWidget);
      },
    );

void update() => testWidgets(
      'Alchemist update test',
      (WidgetTester tester) async {
        await tester.pumpWidget(Counter());

        final labFinder = find.byType(Lab);
        expect(labFinder, findsOneWidget);
        LabState labState = tester.state(find.byType(Lab));

        CounterFlask flask = labState.lookup();
        flask.add(ValueIngredient(1));

        await tester.pump();

        final valueFinder = find.text('1');
        expect(valueFinder, findsOneWidget);
      },
    );

class MockFuse extends Fuse {
  MockFuse() : super(false);

  @override
  int reportExplosion(Object explosion, StackTrace stackTrace) {
    return -42;
  }
}
