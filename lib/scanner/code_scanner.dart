import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CodeScannerPage extends StatefulWidget {
  const CodeScannerPage({super.key});

  @override
  _CodeScannerPageState createState() => _CodeScannerPageState();
}

class _CodeScannerPageState extends State<CodeScannerPage> {
  final MobileScannerController _controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Scanner'),
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              _controller.stop();
              Navigator.pop(context, code); // Pass the scanned code back
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when done
    super.dispose();
  }
}
