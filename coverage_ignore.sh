cd coverage || exit 1
lcov --remove lcov.info "*lib.dart"
lcov --remove lcov.info "lib/src/flasks/ingredients.dart" "lib/src/flasks/potions.dart"
cd ..