#!/bin/bash

# Clean the build
flutter clean

# Get dependencies
flutter pub get

# Run build_runner
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Run analyzer
flutter analyze 