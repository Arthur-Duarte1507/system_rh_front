# sistema_rh

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Execucao web na porta fixa 8080

Este projeto usa o arquivo `web_dev_config.yaml` para fixar a execucao web em:

`http://localhost:8080`

Com isso, ao rodar:

```bash
flutter run -d chrome
```

o Flutter passa a usar a porta 8080 por padrao (Flutter 3.38+).
