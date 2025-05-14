import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random String Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Random String Generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _lengthController = TextEditingController();
  String _generatedString = '';
  final String _chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()-_=+[]{}|;:,.<>/?~'; // Combined characters

  @override
  void dispose() {
    _lengthController.dispose();
    super.dispose();
  }

  void _generateRandomString() {
    final int? length = int.tryParse(_lengthController.text);
    if (length == null || length <= 0) {
      setState(() {
        _generatedString = 'Please enter a valid positive length.';
      });
      return;
    }

    final Random random = Random.secure();
    final String randomString = String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(random.nextInt(_chars.length))));

    setState(() {
      _generatedString = randomString;
    });
  }

  void _copyToClipboard() {
    if (_generatedString.isNotEmpty && _generatedString != 'Please enter a valid positive length.') {
      Clipboard.setData(ClipboardData(text: _generatedString)).then((_) {
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copied to clipboard!')),
          );
        }
       });
    } else {
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing to copy.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _lengthController,
              decoration: const InputDecoration(
                labelText: 'Enter desired string length',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateRandomString,
              child: const Text('Generate String'),
            ),
            const SizedBox(height: 30),
            if (_generatedString.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   const Text(
                    'Generated String:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                     padding: const EdgeInsets.all(12.0),
                     decoration: BoxDecoration(
                       border: Border.all(color: Colors.grey),
                       borderRadius: BorderRadius.circular(4.0),
                     ),
                    child: SelectableText(
                      _generatedString,
                      style: const TextStyle(fontSize: 16, fontFamily: 'monospace'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy to Clipboard',
                    onPressed: _copyToClipboard,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
