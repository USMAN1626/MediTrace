import 'package:flutter/material.dart';
import 'package:scan/scanner/code_scanner.dart';
import 'package:scan/screens/dashboard_screen.dart';

class MedicineScannerPage extends StatefulWidget {
  final String passportNumber;
  final String dob;
  final String category;
  final String breed;
  final String version;

  const MedicineScannerPage({
    super.key,
    required this.passportNumber,
    required this.dob,
    required this.category,
    required this.breed,
    required this.version,
  });

  @override
  _MedicineScannerPageState createState() => _MedicineScannerPageState();
}

class _MedicineScannerPageState extends State<MedicineScannerPage> {
  final TextEditingController gtinController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController batchNumberController = TextEditingController();

  void _handleScanResult(String scannedData) {
    try {
      final gtin = scannedData.substring(2, 16); // Extract GTIN
      final expiryDate =
          "20${scannedData.substring(18, 20)}-${scannedData.substring(20, 22)}-${scannedData.substring(22, 24)}"; // Extract Expiration Date
      final batchNumber = scannedData.substring(26); // Extract Batch Number

      setState(() {
        gtinController.text = gtin;
        expiryDateController.text = expiryDate;
        batchNumberController.text = batchNumber;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid scan format')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medicine Scanner',
          style: TextStyle(fontFamily: 'Helvetica'),
        ),
        backgroundColor: const Color(0xFFD9DFC6), // App bar color
      ),
      body: Container(
        color: const Color(0xFFEFF3EA), // Background color
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Medicine Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Helvetica',
                ),
              ),
              const SizedBox(height: 12),
              _buildTextField(gtinController, 'GTIN'),
              const SizedBox(height: 12),
              _buildTextField(expiryDateController, 'Expiration Date'),
              const SizedBox(height: 12),
              _buildTextField(batchNumberController, 'Batch Number'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(
                    label: 'Scan QR Code',
                    onPressed: () async {
                      final String? scannedData = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CodeScannerPage(),
                        ),
                      );
                      if (scannedData != null) {
                        _handleScanResult(scannedData);
                      }
                    },
                  ),
                  _buildButton(
                    label: 'Sync Data',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlockchainDashboard(
                            passportNumber: widget.passportNumber,
                            dob: widget.dob,
                            category: widget.category,
                            breed: widget.breed,
                            version: widget.version,
                            gtin: gtinController.text,
                            expiryDate: expiryDateController.text,
                            batchNumber: batchNumberController.text,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFFFFDF0), // Field background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0), // Rounded corners
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(fontFamily: 'Helvetica'),
    );
  }

  Widget _buildButton(
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFF2C2), // Button color
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // More rounded corners
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black87, // Button text color
          fontFamily: 'Helvetica',
        ),
      ),
    );
  }
}
