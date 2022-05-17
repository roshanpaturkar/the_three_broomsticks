#!/usr/bin/zsh
flutter --no-color clean
flutter --no-color pub get
flutter build web
firebase deploy

flutter --no-color clean
flutter --no-color pub get
flutter --no-color build apk