import 'package:alchemica/alchemica.dart';
import 'package:flutter_test/flutter_test.dart';

class MockPipe extends Pipe {
  final Label? _label;

  @override
  Label get label => _label ?? super.label;

  MockPipe([this._label]);

  @override
  void install(PipeContext context) {
    // Intentionally left blank
  }

  @override
  void pass(Ingredient ingredient) {
    // Intentionally left blank
  }

  @override
  void uninstall() {
    // Intentionally left blank
  }
}

void main() => group(
      'Pipe unit tests',
      () {
        searchByType();
        searchByLabel();
      },
    );

void searchByType() => test(
      'Search by type',
      () {
        Pipe pipe = MockPipe();

        MockPipe? fromSearch = pipe.find();
        expect(identical(pipe, fromSearch), true);
      },
    );

void searchByLabel() => test(
      'Search by label',
      () {
        Pipe pipe = MockPipe(Label(1));

        Pipe? fromSearch = pipe.find(Label(1));
        expect(identical(pipe, fromSearch), true);
      },
    );
