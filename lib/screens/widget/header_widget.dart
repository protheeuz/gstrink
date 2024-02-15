import 'package:flutter/material.dart';
import 'package:galers/screens/components/spacer.dart';
import 'package:galers/screens/declaration/constants.dart';
import 'package:get/get.dart';

class HeaderWidgets extends StatelessWidget {
  const HeaderWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Text("Tambahkan kartu lain ke dalam tabungan.",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.75), fontSize: 20)),
          ),
          WidthSpacer(myWidth: kSpacing * 5),
          Container(
            decoration: BoxDecoration(
                borderRadius: kBorderRadius / 1.5, color: accentColor),
            child: IconButton(
              onPressed: () => Get.snackbar("Terjadi Kesalahan", "Anda belum disetujui untuk menambahkan kartu."),
              icon: const Icon(
                Icons.add_outlined,
                color: Colors.white,
                size: 30,
              ),
              
            ),
          ),
        ],
      ),
    );
  }
}
