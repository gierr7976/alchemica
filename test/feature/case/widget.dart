part of 'case_test.dart';

class PotionCaseMock extends StatelessWidget {
  final int? initial;

  const PotionCaseMock({Key? key, this.initial}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Material(
      child: Lab(
        recipe: MockRecipe(initial),
        child: PotionCase<MockRecipe, MockFlask, BrewedMock>(
          brewed: (context, potion) => Text(
            potion.value.toString(),
          ),
          poisoned: (context, potion) => Text('P'),
          underbrewed: (context, potion) => Text('U'),
        ),
      ),
    ),
  );
}
