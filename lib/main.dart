import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFBF5700), // A warm, burnt orange
          onPrimary: Colors.white,
          secondary: Color(0xFFD4AF37), // A muted gold
          onSecondary: Colors.black,
          error: Color(0xFFB71C1C), // A deep red for errors
          onError: Colors.white,
          background: Color(0xFFFDF6E3), // A light, sandy beige
          onBackground: Color(0xFF4E342E), // A dark, earthy brown for text
          surface: Color(0xFFEEE8D5), // An earthy tan for card surfaces
          onSurface: Color(0xFF4E342E), // A dark, earthy brown for text
        ),
      ),
      home: const MyHomePage(title: 'Advanced Counter'),
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
  int _counter = 0;
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = '1'; // Default amount
  }

  @override
  void dispose() {
    _amountController.dispose(); // Clean up the controller
    super.dispose();
  }

  int _getAmount() {
    // Safely parse the integer from the text field.
    // Default to 1 if parsing fails or the text is empty.
    return int.tryParse(_amountController.text) ?? 1;
  }

  void _incrementCounter() {
    setState(() {
      _counter += _getAmount();
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter -= _getAmount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Builder(
          builder: (context) {
            // This logic creates colored capital letters for the title.
            final List<TextSpan> titleSpans = [];
            final List<Color> capitalColors = [
              Theme.of(context).colorScheme.error, // Use deep red from theme
              Theme.of(
                context,
              ).colorScheme.onBackground, // Use dark brown from theme
            ];
            int colorIndex = 0;

            final RegExp exp = RegExp(r'([A-Z])|([^A-Z]+)');
            exp.allMatches(widget.title).forEach((match) {
              final capital = match.group(1);
              final other = match.group(2);

              if (capital != null) {
                titleSpans.add(
                  TextSpan(
                    text: capital,
                    style: TextStyle(
                      color: capitalColors[colorIndex % capitalColors.length],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
                colorIndex++;
              } else if (other != null) {
                titleSpans.add(TextSpan(text: other));
              }
            });

            return RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: titleSpans,
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Current Value:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                // Allow only digits
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _decrementCounter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                    ),
                    icon: const Icon(Icons.remove),
                    label: const Text('Subtract'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _incrementCounter,
                    style: ElevatedButton.styleFrom(
                      // A standard blue color as requested.
                      backgroundColor: Colors.blue,
                      // White text and icon for good contrast on a blue background.
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
