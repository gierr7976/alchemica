part of 'alchemist_test.dart';

class Counter extends StatelessWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Lab(
            builder: () => CounterFlask(),
            child: Alchemist<CounterFlask, CounterPotion>(
              underbrewedDrinker: (context, potion) => Text('LOADING'),
              poisonedDrinker: (context, potion) => Text('ERROR'),
              brewedDrinker: (context, potion) => Text(potion.value.toString()),
            ),
          ),
        ),
      );
}
