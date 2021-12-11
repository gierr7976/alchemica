part of alchemica.piping;

abstract class Pipe {
  Label get label;

  @protected
  void drip(PipeContext context);

  T? find<T extends Pipe>([Label? label]);

  Map<Label, Pipe> extract();
}
