part of alchemica.consumers;

abstract class Vial<P extends Potion?> extends StatelessWidget {
  final P potion;

  const Vial({
    Key? key,
    required this.potion,
  }) : super(key: key);

  void add(BuildContext context, Ingredient ingredient) =>
      Lab.of(context).add(ingredient);
}
