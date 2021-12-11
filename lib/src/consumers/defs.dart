part of alchemica.consumers;

typedef AlchemicaWidgetBuilder<P extends Potion> = Widget Function(
    BuildContext context, P potion);

typedef AlchemicaAlarm<P extends Potion> = void Function(
    BuildContext, P potion);

typedef AlchemicaCondition = bool Function(Potion oldPotion, Potion newPotion);

typedef AlchemicaOnePotionCondition = bool Function(Potion potion);

abstract class AlchemicaConditions {
  AlchemicaCondition otherType() => (o, n) => o.runtimeType != n.runtimeType;

  AlchemicaCondition exactType<T extends Potion>() => (o, n) => n is T;

  AlchemicaCondition notEqual() => (o, n) => o != n;

  AlchemicaCondition meets(AlchemicaOnePotionCondition condition) =>
      (o, n) => condition(n);
}
