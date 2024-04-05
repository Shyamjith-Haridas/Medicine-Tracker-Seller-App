// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller/routes_file.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //
  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == '' || password == '') {
      const snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        content: Text(
          "Please fill all fields..",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        bool isApproved = await getApproval(email);
        print("try $isApproved");

        if (userCredential.user != null) {
          Navigator.popUntil(context, (route) => route.isFirst);

          Navigator.of(context)
              .pushReplacementNamed(isApproved ? Routes.home : Routes.pending);
        }
      } on FirebaseAuthException catch (exception) {
        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          content: Text(
            exception.code.toString(),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<bool> getApproval(String email) async {
    print(email);
    bool? isapproved;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("seller_database")
        .where("email", isEqualTo: email)
        .get();
    var doc = querySnapshot.docs.first;
    Map<String, dynamic> userMap = doc.data()! as Map<String, dynamic>;

    isapproved = userMap["isapproved"]!;
    print("usermap $isapproved");

    return isapproved!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      label: Text(
                        "E-Mail",
                      ),
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      label: Text(
                        "Password",
                      ),
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: login,
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
