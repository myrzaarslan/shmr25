import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinAuthScreen extends StatefulWidget {
  final bool isSetup;
  final String? title;
  final Function(String)? onPinEntered;
  final Function(String)? onPinConfirmed;

  const PinAuthScreen({
    super.key,
    this.isSetup = false,
    this.title,
    this.onPinEntered,
    this.onPinConfirmed,
  });

  @override
  State<PinAuthScreen> createState() => _PinAuthScreenState();
}

class _PinAuthScreenState extends State<PinAuthScreen> {
  final List<String> _pin = [];
  final List<String> _confirmPin = [];
  bool _isConfirming = false;
  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? (widget.isSetup ? 'Установка PIN' : 'Введите PIN')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Icon(
            _isError ? Icons.error : Icons.lock,
            size: 64,
            color: _isError ? Colors.red : Colors.grey,
          ),
          const SizedBox(height: 20),
          Text(
            _getPinText(),
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final currentPin = _isConfirming ? _confirmPin : _pin;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < currentPin.length
                      ? (_isError ? Colors.red : Colors.green)
                      : Colors.grey[300],
                ),
              );
            }),
          ),
          const SizedBox(height: 60),
          _buildNumpad(),
        ],
      ),
    );
  }

  String _getPinText() {
    if (_isError) {
      return 'PIN не совпадает. Попробуйте еще раз.';
    }
    if (widget.isSetup) {
      if (_isConfirming) {
        return 'Подтвердите PIN';
      } else {
        return 'Введите новый PIN';
      }
    } else {
      return 'Введите PIN';
    }
  }

  Widget _buildNumpad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('1'),
            _buildNumberButton('2'),
            _buildNumberButton('3'),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('4'),
            _buildNumberButton('5'),
            _buildNumberButton('6'),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('7'),
            _buildNumberButton('8'),
            _buildNumberButton('9'),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 80),
            _buildNumberButton('0'),
            _buildDeleteButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () => _addDigit(number),
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: _deleteDigit,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
          ),
          child: const Icon(Icons.backspace, size: 24),
        ),
      ),
    );
  }

  void _addDigit(String digit) {
    if (_pin.length >= 4) return;

    setState(() {
      _isError = false;
      if (_isConfirming) {
        _confirmPin.add(digit);
        if (_confirmPin.length == 4) {
          _checkPin();
        }
      } else {
        _pin.add(digit);
        if (_pin.length == 4) {
          if (widget.isSetup) {
            _isConfirming = true;
          } else {
            _submitPin();
          }
        }
      }
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _deleteDigit() {
    setState(() {
      _isError = false;
      if (_isConfirming) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin.removeLast();
        }
      } else {
        if (_pin.isNotEmpty) {
          _pin.removeLast();
        }
      }
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _checkPin() {
    final pinString = _pin.join();
    final confirmPinString = _confirmPin.join();

    if (pinString == confirmPinString) {
      widget.onPinConfirmed?.call(pinString);
      Navigator.of(context).pop(pinString);
    } else {
      setState(() {
        _isError = true;
        _confirmPin.clear();
      });
    }
  }

  void _submitPin() {
    final pinString = _pin.join();
    widget.onPinEntered?.call(pinString);
    Navigator.of(context).pop(pinString);
  }
} 