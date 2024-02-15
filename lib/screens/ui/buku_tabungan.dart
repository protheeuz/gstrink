import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BukuPage extends StatefulWidget {
  const BukuPage({super.key});

  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  final _database = FirebaseDatabase.instance.reference().child('tabungan');
  List<int> _nominals = [];

  @override
  void initState() {
    super.initState();
    _setupNominalsListener();
  }


  void _setupNominalsListener() {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      String uid = user.uid;

    _database.child('$uid/riwayat').onChildAdded.listen((event) {
      // Saat ada perubahan pada child (riwayat), ambil nilai dan tambahkan ke list
      int nominal = (event.snapshot.child('total').value as int?) ?? 0;
      setState(() {
        _nominals.add(nominal);
      });
    });
    // Lakukan sesuatu dengan data event di sini
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buku Tabungan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nominal-nominal Total Tabungan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _nominals.isEmpty
                ? const Text('Belum ada data.')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _nominals.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Rp. ${_nominals[index]}'),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
