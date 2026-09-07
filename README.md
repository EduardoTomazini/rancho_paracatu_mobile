# rancho_paracatu_mobile

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

## Configuração local do protótipo

Os identificadores de infraestrutura e as credenciais usadas no protótipo
acadêmico não são armazenados no repositório. Para executar a integração
legada, copie `config.example.json` para `config.local.json`, preencha os
valores localmente e execute:

```sh
flutter run --dart-define-from-file=config.local.json
```

`config.local.json` é ignorado pelo Git. As credenciais administrativas
legadas são adequadas somente para demonstração local: aplicações Flutter Web
não conseguem manter segredos no navegador. A autenticação de produção deve
ser feita por um backend.
