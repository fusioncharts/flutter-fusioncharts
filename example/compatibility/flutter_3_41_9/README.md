# Flutter 3.41.9 compatibility harness

This minimal application keeps the native Android and iOS projects generated
by Flutter 3.41.9. It verifies the PRD target independently from the current
gallery in `example/`.

Run it with the official Flutter 3.41.9 SDK and JDK 17:

```sh
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
flutter build ios --simulator --no-codesign
```
