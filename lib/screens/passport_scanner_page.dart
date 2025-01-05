import 'package:flutter/material.dart';
import 'package:scan/scanner/code_scanner.dart';
import 'package:scan/screens/medicine_scanner_page.dart';

class PassportScannerPage extends StatefulWidget {
  const PassportScannerPage({super.key});

  @override
  _PassportScannerPageState createState() => _PassportScannerPageState();
}

class _PassportScannerPageState extends State<PassportScannerPage> {
  final TextEditingController passportController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController versionController = TextEditingController();

  void _handleScanResult(String scannedData) {
    if (scannedData.isNotEmpty && scannedData.length >= 25) {
      setState(() {
        passportController.text = scannedData.substring(0, 14); // Passport No
        dobController.text = scannedData.substring(14, 22); // DOD
        categoryController.text = scannedData[22]; // Category
        breedController.text = scannedData.substring(23, 26); // Breed
        versionController.text = scannedData.substring(27); // Version
      });
    } else {
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
          'Passport Scanner',
          style: TextStyle(fontFamily: 'Helvetica'),
        ),
        backgroundColor: const Color(0xFFD9DFC6), // App bar color
      ),
      body: Container(
        color: const Color(0xFFEFF3EA), // Background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Livestock Passport Scanner',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Helvetica',
              ),
            ),
            const SizedBox(height: 16),
            ..._buildTextFields(),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(
                  label: 'Scan Passport',
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
                  label: 'Go to Medicine Scanner',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicineScannerPage(
                          passportNumber: passportController.text,
                          dob: dobController.text,
                          category: categoryController.text,
                          breed: breedController.text,
                          version: versionController.text,
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
    );
  }

  List<Widget> _buildTextFields() {
    return [
      _buildTextField(passportController, 'Passport No'),
      _buildTextField(dobController, 'Date of Birth'),
      _buildTextField(categoryController, 'Category'),
      _buildTextField(breedController, 'Breed'),
      _buildTextField(versionController, 'Version'),
    ];
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
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
      ),
    );
  }

  Widget _buildButton(
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 204, 186, 121), // Button color
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // More rounded corners
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black87, // Text color
          fontFamily: 'Helvetica',
        ),
      ),
    );
  }
}
