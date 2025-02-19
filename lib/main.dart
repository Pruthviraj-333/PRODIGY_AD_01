import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = "";
  String output = "0";

  void buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        input = "";
        output = "0";
      } else if (value == "⌫") {
        input = input.isNotEmpty ? input.substring(0, input.length - 1) : "";
      } else if (value == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(input.replaceAll('×', '*').replaceAll('÷', '/'));
          ContextModel cm = ContextModel();
          output = "${exp.evaluate(EvaluationType.REAL, cm)}";
        } catch (e) {
          output = "Error";
        }
      } else {
        input += value;
      }
    });
  }

  Widget buildButton(String text, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(22),
            shape: CircleBorder(),
            backgroundColor: color ?? Colors.grey[850],
          ),
          onPressed: () => buttonPressed(text),
          child: Text(
            text,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(input, style: TextStyle(fontSize: 36, color: Colors.white54)),
                  Text(output, style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ),
          Divider(color: Colors.white24),
          Column(
            children: [
              buildRow(["7", "8", "9", "÷"], Colors.orange),
              buildRow(["4", "5", "6", "×"], Colors.orange),
              buildRow(["1", "2", "3", "-"], Colors.orange),
              buildRow(["C", "0", "⌫", "+"], Colors.orange),
              buildRow([".", "00", "=", ""], Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRow(List<String> buttons, Color opColor) {
    return Row(
      children: buttons.map((btn) => buildButton(btn, color: btn == "=" ? Colors.green : (btn == "C" || btn == "⌫" ? Colors.red : (btn == "+" || btn == "-" || btn == "×" || btn == "÷" ? opColor : null)))).toList(),
    );
  }
}
