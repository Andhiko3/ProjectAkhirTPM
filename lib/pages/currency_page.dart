import 'package:flutter/material.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  final TextEditingController amountController = TextEditingController();

  String from = "IDR";
  String to = "USD";
  double result = 0;

  void convert() {
    double amount = double.tryParse(amountController.text) ?? 0;

    Map<String, double> rates = {
      "IDR": 1,
      "USD": 16000,
      "EUR": 17500,
    };

    setState(() {
      result = amount * rates[from]! / rates[to]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Currency Converter")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount",
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: from,
              items: ["IDR", "USD", "EUR"]
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  from = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: to,
              items: ["IDR", "USD", "EUR"]
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  to = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: convert,
              child: const Text("Convert"),
            ),
            const SizedBox(height: 20),
            Text(
              result.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}