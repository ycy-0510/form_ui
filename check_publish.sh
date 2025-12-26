#!/bin/bash
set -e

echo "Running Dart Format Check..."
dart format --output=none --set-exit-if-changed .

echo "Running Flutter Analyze..."
flutter analyze

echo "Running Tests..."
flutter test

echo "Running Publish Dry Run..."
flutter pub publish --dry-run

echo "✅ All checks passed! You are ready to publish."
