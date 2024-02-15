import 'package:flutter/material.dart';
import 'package:galers/screens/components/appbar.dart';
import 'package:galers/screens/components/spacer.dart';
import 'package:galers/screens/declaration/constants.dart';
import 'package:galers/screens/ui/login_screen.dart';
import 'package:galers/screens/ui/tabungan_page.dart';
import 'package:get/get.dart';

import '../components/primary_button.dart';
import '../widget/header_widget.dart';
import '../widget/list_tile.dart';
import '../widget/swiper_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'buku_tabungan.dart';
import 'target_page.dart';

class HomePage extends StatelessWidget {
  const HomePage(
      {super.key, required this.title, required this.currentUserUid});
  final String title;
  final String currentUserUid;

  // final String currentUid;

  @override
  Widget build(BuildContext context) {
    const allowedUid = "HJ0qOKwqhsTIXEwu1phoL0SXr2G3";

    return Scaffold(
      appBar: buildAppBar(appBarTitle: title),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CardLayout(),
            HeightSpacer(myHeight: kSpacing),
            Settings(
              currentUserUid: currentUserUid,
            ),
            HeightSpacer(myHeight: kSpacing)
          ],
        ),
      ),
    );
  }
}

class CardLayout extends StatelessWidget {
  const CardLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 400,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Column(
        children: [
          HeightSpacer(myHeight: kSpacing),
          const HeaderWidgets(),
          HeightSpacer(myHeight: kSpacing / 2),
          const SwiperBuilder(),
        ],
      ),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({
    Key? key,
    required this.currentUserUid,
  }) : super(key: key);

  final String currentUserUid;
  final allowedUid = "HJ0qOKwqhsTIXEwu1phoL0SXr2G3";

  @override
  Widget build(BuildContext context) {
    bool showTargetTabungan = currentUserUid == allowedUid;
    return Padding(
      padding: kHPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Fitur',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          HeightSpacer(myHeight: kSpacing),
          InkWell(
            onTap: () => Get.to(() => const TabunganPage()),
            child: const ListTileBldr(
              title: 'Lihat Tabungan',
              icon: Icons.bar_chart_outlined,
            ),
          ),
          HeightSpacer(myHeight: kSpacing / 2),
          InkWell(
            onTap: () => Get.to(() => const BukuPage()),
            child: const ListTileBldr(
              title: 'Buku Tabungan',
              icon: Icons.book_outlined,
            ),
          ),
          HeightSpacer(myHeight: kSpacing / 2),
          if (showTargetTabungan)
            InkWell(
              onTap: () => Get.to(() => const TargetPage()),
              child: const ListTileBldr(
                title: 'Target Tabungan',
                icon: Icons.monetization_on,
              ),
            ),
          HeightSpacer(myHeight: kSpacing * 2),
          Align(
            alignment: Alignment.bottomCenter,
            child: PrimaryBtn(
              btnText: 'Logout',
              btnFunc: () {
                Get.to(() => const LoginPage());
              },
            ),
          ),
        ],
      ),
    );
  }
}
