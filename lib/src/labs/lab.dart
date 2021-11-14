part of labs;

typedef SinglePipeBuilder = Flask Function();
typedef MultiPipeBuilder = List<Flask> Function();

class Lab extends StatefulWidget {
  static LabState of(BuildContext context) =>
      context.findAncestorStateOfType()!;

  final SinglePipeBuilder? builder;
  final MultiPipeBuilder? multiBuilder;
  final Widget child;

  const Lab({
    Key? key,
    required this.child,
    this.builder,
    this.multiBuilder,
  })  : assert(
          (builder != null) ^ (multiBuilder != null),
          "builder either multiBuilder should be given",
        ),
        super(key: key);

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      builder != null ? _SinglePipeLabState() : _MultiPipeLabState();
}

abstract class LabState extends State<Lab> {
  @override
  void initState() {
    super.initState();

    buildPiping();
  }

  void buildPiping();

  @override
  Widget build(BuildContext context) => widget.child;
}

extension XOR on bool {
  bool operator ^(bool other) => (this || other) && !(this && other);
}
