import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.signInAnonymously(); // Autenticação anônima

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Temperatura',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _celsiusController = TextEditingController();
  String _fahrenheitResult = '';
  String _lastConversion = 'Nenhuma conversão anterior';

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _loadLastConversion();
  }

  @override
  void dispose() {
    _celsiusController.dispose();
    super.dispose();
  }

  Future<void> _convertAndSave() async {
    try {
      final input = _celsiusController.text.trim();
      if (input.isEmpty) return;

      final double? celsiusValue = double.tryParse(input);
      if (celsiusValue == null) {
        setState(() {
          _fahrenheitResult = 'Valor inválido';
        });
        return;
      }

      final double fahrenheit = (celsiusValue * 9 / 5) + 32;

      setState(() {
        _fahrenheitResult = '${fahrenheit.toStringAsFixed(2)} °F';
      });

      // Salvar a conversão mais recente no Realtime Database
      try {
        await _database.child('conversions/latest').set({
          'celsius': celsiusValue,
          'fahrenheit': fahrenheit,
          'timestamp': ServerValue.timestamp, // CORREÇÃO AQUI
        });
        print('Dados salvos com sucesso no Realtime Database');
      } catch (databaseError) {
        print('Erro ao salvar no Realtime Database: $databaseError');
      }

      await _loadLastConversion();
    } catch (e) {
      print('Erro na conversão: $e');
      setState(() {
        _fahrenheitResult = 'Erro na conversão';
      });
    }
  }

  Future<void> _loadLastConversion() async {
    try {
      final snapshot = await _database.child('conversions/latest').get();

      if (snapshot.exists) {
        final data = snapshot.value as Map?;
        if (data != null && data.containsKey('celsius') && data.containsKey('fahrenheit')) {
          final celsius = data['celsius'];
          final fahrenheit = data['fahrenheit'];

          setState(() {
            _lastConversion = '${celsius.toString()} °C = ${fahrenheit.toString()} °F';
          });
        }
      } else {
        print('Nenhuma conversão encontrada no Realtime Database');
      }
    } catch (e) {
      print('Erro ao carregar a última conversão: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversor C → F"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Última conversão:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(_lastConversion),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _celsiusController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Temperatura em Celsius',
                border: OutlineInputBorder(),
                suffixText: '°C',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertAndSave,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Converter'),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                _fahrenheitResult,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
