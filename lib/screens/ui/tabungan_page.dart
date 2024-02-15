import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TabunganPage extends StatefulWidget {
  const TabunganPage({super.key});

  @override
  _TabunganPageState createState() => _TabunganPageState();
}

class _TabunganPageState extends State<TabunganPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  late User _user;
  late String _uid;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _uid = _user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabungan Kamu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Tabungan',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    StreamBuilder(
                      stream: _database.child('tabungan/$_uid/total').onValue,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data!.snapshot.value != null) {
                          int totalTabungan =
                              snapshot.data!.snapshot.value as int;
                          return Text(
                            'Rp. $totalTabungan',
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.green,
                            ),
                          );
                        } else {
                          // Jika data tidak ada, tampilkan 0
                          return const Text(
                            'Rp. 0',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.green,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Riwayat Tabungan',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    StreamBuilder(
                      stream: _database.child('tabungan/$_uid/riwayat').onValue,
                      builder: (context, AsyncSnapshot snapshot ) {
                        if (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data!.snapshot.value != null) {
                          // Konversi data ke List
                          List<dynamic> riwayat =
                              snapshot.data!.snapshot.value as List<dynamic>;

                          return Expanded(
                            child: ListView.builder(
                              itemCount: riwayat.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text('Rp. ${riwayat[index]}'),
                                  // Tambahkan detail riwayat jika diperlukan
                                  // subtitle: Text('Detail lainnya'),
                                );
                              },
                            ),
                          );
                        } else {
                          // Jika data tidak ada, tampilkan pesan
                          return const Text('Belum ada riwayat tabungan.');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: TabunganPage(),
    ),
  );
}
