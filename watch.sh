while inotifywait -r -e modify,create,delete assets; do
  flutter pub run build_runner build --delete-conflicting-outputs
done