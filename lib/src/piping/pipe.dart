part of alchemica.piping;

abstract class Pipe {
  Label get label;

  @protected
  void drip(PipeContext context);

  T? find<T extends Pipe>();

  Map<Label, Pipe> extract();
}
