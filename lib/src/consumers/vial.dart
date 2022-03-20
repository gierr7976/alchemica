part of alchemica.consumers;

abstract class Vial<P extends Potion?> extends StatelessWidget {
  final P? potion;

  const Vial({
    Key? key,
    required Potion? potion,
  })  : potion = potion is P ? potion : null,
        super(key: key);

  const Vial.spelled({
    Key? key,
    this.potion,
  }) : super(key: key);
}

typedef VialBuilder = Vial Function(Potion potion);

class VialFactory<P extends Potion> {
  final VialBuilder builder;

  const VialFactory(this.builder);

  bool checkPotion(Potion potion) => potion is P;

  Vial call(Potion potion) => builder(potion);
}