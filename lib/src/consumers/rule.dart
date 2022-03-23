part of alchemica.consumers;

abstract class Rule {
  Vial map(BuildContext context, Potion potion);

  Vial onUnknown(BuildContext context, Potion potion) =>
      throw StateError(
        '''
        Unknown potion: $potion\n
        Did you forgot to map this one?
        '''
      );
}
