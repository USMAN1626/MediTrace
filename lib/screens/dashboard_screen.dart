import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const InfoTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF0), // Tile background color
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2), // Light border
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Helvetica',
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontFamily: 'Helvetica',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlockchainDashboard extends StatelessWidget {
  final String passportNumber;
  final String dob;
  final String category;
  final String breed;
  final String version;
  final String gtin;
  final String expiryDate;
  final String batchNumber;

  const BlockchainDashboard({
    super.key,
    required this.passportNumber,
    required this.dob,
    required this.category,
    required this.breed,
    required this.version,
    required this.gtin,
    required this.expiryDate,
    required this.batchNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blockchain Dashboard',
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
                'Passport Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Helvetica',
                ),
              ),
              const SizedBox(height: 12),
              InfoTile(title: 'Passport Number', value: passportNumber),
              InfoTile(title: 'Date of Birth', value: dob),
              InfoTile(title: 'Category', value: category),
              InfoTile(title: 'Breed', value: breed),
              InfoTile(title: 'Version', value: version),
              const Divider(
                height: 32,
                thickness: 2,
                color: Colors.black54,
              ),
              const Text(
                'Medication Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Helvetica',
                ),
              ),
              const SizedBox(height: 12),
              InfoTile(title: 'GTIN', value: gtin),
              InfoTile(title: 'Expiry Date', value: expiryDate),
              InfoTile(title: 'Batch Number', value: batchNumber),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      var connectivityResult =
                          await Connectivity().checkConnectivity();

                      if (connectivityResult == ConnectivityResult.none) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'No internet connection. Data saved locally.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      } else {
                        await FirebaseFirestore.instance
                            .collection('blockchainData')
                            .add({
                          'passportNumber': passportNumber,
                          'dob': dob,
                          'category': category,
                          'breed': breed,
                          'version': version,
                          'GTIN': gtin,
                          'expiryDate': expiryDate,
                          'batchNumber': batchNumber,
                          'timestamp': FieldValue.serverTimestamp(),
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Data synced to Firestore successfully.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error saving data: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF2C2), // Button color
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: const Text(
                    'Save to Firestore',
                    style: TextStyle(
                      color: Colors.black87, // Button text color
                      fontFamily: 'Helvetica',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
