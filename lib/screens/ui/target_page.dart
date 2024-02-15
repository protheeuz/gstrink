import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class TargetPage extends StatefulWidget {
  const TargetPage({super.key});

  @override
  _TargetPageState createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  final _database = FirebaseDatabase.instance.reference();
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Target Tabungan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan Nominal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _tambahNominal();
              },
              child: const Text('Tambah Nominal'),
            ),
            const Divider(),
            const Text(
              'Atur Target Tabungan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _aturTargetTabungan();
              },
              child: const Text('Atur Target Tabungan'),
            ),
          ],
        ),
      ),
    );
  }

  void _tambahNominal() {
    int nominal = int.tryParse(_nominalController.text) ?? 0;

    if (nominal > 0) {
      // Menambahkan nominal ke total tabungan di Firebase
      _database.child('tabungan/your_user_uid/total').set(ServerValue.increment(nominal));

      // Bersihkan field setelah menambah nominal
      _nominalController.clear();
    }
    Get.snackbar("Berhasil", "Target Tabungan sudah ditentukan");
  }

  void _aturTargetTabungan() {
    int targetTabungan = int.tryParse(_targetController.text) ?? 0;

    if (targetTabungan > 0) {
      // Menyimpan target tabungan ke Firebase
      _database.child('tabungan/target').set(targetTabungan);

      // Bersihkan field setelah mengatur target tabungan
      _targetController.clear();
    }
    Get.snackbar("Berhasil", "Target Tabungan sudah ditentukan");
  }
}
