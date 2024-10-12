import 'package:flutter/material.dart';
import 'btn_values.dart';

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String number1 = '';
  String operand = '';
  String number2 = '';
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            //text
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.38,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(16),
                child: Text(
                  '$number1$operand$number2'.isEmpty
                      ? '0'
                      : '$number1$operand$number2',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.end,
                ),
              ),
            ),

            //buttons
            Wrap(
              children: Btn.buttonValues
                  .map((values) => SizedBox(
                      width: values == Btn.n0
                          ? screenSize.width / 2
                          : screenSize.width / 4,
                      height: screenSize.width / 5,
                      child: buildButton(values)))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  void onBtnTab(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }
    if (value == Btn.per) {
      convertToPercentage();
      return;
    }
    if (value == Btn.calculate) {
      calculateResult();
      return;
    }

    appendValues(value);
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = '';
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void clearAll() {
    setState(() {
      number1 = '';
      operand = '';
      number2 = '';
    });
  }

  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculateResult();
    }

    if (operand.isNotEmpty) {
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = '${(number / 100)}';
      operand = '';
      number2 = '';
    });
  }

  void calculateResult() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;
    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);
    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      number1 = "$result";
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = '';
      number2 = '';
    });
  }

  void appendValues(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculateResult();
      }
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = '0.';
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = '0.';
      }
      number2 += value;
    }

    setState(() {});
  }

  Widget buildButton(values) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
          clipBehavior: Clip.hardEdge,
          color: getBtnColor(values),
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Colors.white24)),
          child: InkWell(
              onTap: () => onBtnTab(values),
              child: Center(
                  child: Text(
                values,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              )))),
    );
  }

  Color getBtnColor(values) {
    return [Btn.del, Btn.clr].contains(values)
        ? Colors.blueGrey
        : [
            Btn.add,
            Btn.subtract,
            Btn.multiply,
            Btn.divide,
            Btn.per,
            Btn.dot,
            Btn.calculate
          ].contains(values)
            ? Colors.amber.shade700
            : Colors.grey.shade800;
  }
}
