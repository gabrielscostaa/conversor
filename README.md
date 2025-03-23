🌡️ Conversor de Temperatura - Flutter
Um aplicativo Flutter que converte temperaturas de Celsius para Fahrenheit e armazena o histórico de conversões no Firebase.
📋 Funcionalidades

Conversão de temperatura de Celsius para Fahrenheit
Armazenamento do histórico de conversões no Firebase
Visualização do histórico de conversões
Interface responsiva e amigável
Compatível com Android e iOS

🚀 Tecnologias Utilizadas

Flutter
Dart
Firebase Firestore
Firebase Authentication (opcional)

📦 Instalação

Clone o repositório:

Copiargit clone https://github.com/seu-usuario/conversor-temperatura-flutter.git
cd conversor-temperatura-flutter

Configure o Flutter:

Certifique-se de ter o Flutter instalado. Instruções de instalação
Execute flutter doctor para verificar se tudo está configurado corretamente


Configure o Firebase:

Crie um projeto no Firebase Console
Adicione aplicativos Android e iOS ao seu projeto
Siga as instruções para configurar o Firebase em cada plataforma
Baixe os arquivos de configuração (google-services.json para Android e GoogleService-Info.plist para iOS)
Coloque-os nas pastas apropriadas do projeto


Instale as dependências:

Copiarflutter pub get

Execute o aplicativo:

Copiarflutter run
🔧 Configuração do Firebase no Flutter

Adicione as dependências no pubspec.yaml:

yamlCopiardependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.15.0
  cloud_firestore: ^4.8.4
  # Outras dependências conforme necessário

Inicialize o Firebase em seu main.dart:

dartCopiarimport 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

🔧 Como Usar

Abra o aplicativo no seu dispositivo ou emulador
Digite a temperatura em Celsius no campo de entrada
Toque no botão "Converter"
O resultado será exibido e salvo automaticamente no Firebase
Visualize o histórico de conversões na tela de histórico

📊 Estrutura do Banco de Dados (Firestore)
Copiarconversoes (collection)
  │
  ├── documento1
  │     ├── celsius: 25
  │     ├── fahrenheit: 77
  │     └── timestamp: Timestamp
  │
  ├── documento2
  │     ├── celsius: 30
  │     ├── fahrenheit: 86
  │     └── timestamp: Timestamp
  │
  └── ...

🧪 Implementação da Conversão em Dart

dartCopiardouble celsiusToFahrenheit(double celsius) {
  return celsius * 9/5 + 32;
}
