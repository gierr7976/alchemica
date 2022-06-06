part of alchemica.consumers;

abstract class Rule {
  Widget map(BuildContext context, Potion potion);

  Widget unknown(BuildContext context, Potion potion) => throw StateError('''
        Unknown potion: $potion\n
        Did you forgot to map this one?
        ''');

  @Deprecated('Use unknown instead')
  Vial onUnknown(BuildContext context, Potion potion) => throw StateError('''
        Unknown potion: $potion\n
        Did you forgot to map this one?
        ''');
}
