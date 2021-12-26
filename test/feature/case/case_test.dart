import 'package:alchemica/alchemica.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fuse.dart';

part 'flask.dart';

part 'widget.dart';

void main() => group(
      'PotionCase tests',
      () {
        setUpAll(set);
        init();
        normal();
        broken();
      },
    );

void set() {
  MockFuse.inject();
}

void init() => testWidgets(
      'Initialization test',
      (tester) async {
        await tester.pumpWidget(PotionCaseMock());

        expect(find.text('U'), findsOneWidget);
      },
    );

void normal() => testWidgets(
      'Normal flask behavior test',
      (tester) async {
        await tester.pumpWidget(
          PotionCaseMock(initial: 0),
        );

        LabState lab = tester.state(find.byType(Lab));
        MockFlask flask = lab.find()!;

        flask.add(IncIngredient());

        await tester.pump();

        expect(find.text('1'), findsOneWidget);
      },
    );

void broken() => testWidgets(
  'Abnormal flask behavior test',
      (tester) async {
    await tester.pumpWidget(
      PotionCaseMock(initial: 0),
    );

    LabState lab = tester.state(find.byType(Lab));
    MockFlask flask = lab.find()!;

    flask.add(IncIngredient(true));

    await tester.pump();

    expect(find.text('P'), findsOneWidget);
  },
);