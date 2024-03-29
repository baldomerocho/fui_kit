#!/bin/bash
./generate_icons_map.sh lib/maps/bold_rounded.dart BoldRounded assets/icons/bold/rounded/svg/ "fi-br-"
./generate_icons_map.sh lib/maps/bold_straight.dart BoldStraight assets/icons/bold/straight/svg/ "fi-bs-"

./generate_icons_map.sh lib/maps/regular_rounded.dart RegularRounded assets/icons/regular/rounded/svg/ "fi-rr-"
./generate_icons_map.sh lib/maps/regular_straight.dart RegularStraight assets/icons/regular/straight/svg/ "fi-rs-"

./generate_icons_map.sh lib/maps/solid_rounded.dart SolidRounded assets/icons/solid/rounded/svg/ "fi-sr-"
./generate_icons_map.sh lib/maps/solid_straight.dart SolidStraight assets/icons/solid/straight/svg/ "fi-ss-"

dart format lib/maps
dart analyze lib/maps

# set description: in pubspec.yaml, count the number of icons


