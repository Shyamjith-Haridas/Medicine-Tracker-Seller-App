import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:seller/routes_file.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("seller_database")
              .where("email",
                  isEqualTo: FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            final userData = snapshot.data!.docs;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (userData.isEmpty) {
              return const Center(child: Text('No user data found.'));
            }

            final userMap = userData.first.data();

            if (userMap["isapproved"]) {
              Navigator.pushNamed(context, Routes.home);
            }

            return Center(
              child: LottieBuilder.asset("assets/animations/loading.json"),
            );
          },
        ),
      ),
    );
  }
}
