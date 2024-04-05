// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller/routes_file.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // variables
  // String userName = '', email = '', password = '';

  // controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // request admin function
  Future<void> requestToAdmin() async {
    Map<String, dynamic> sellerData = {
      "username": usernameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "isapproved": false,
    };

    if (sellerData["username"] == '' ||
        sellerData["email"] == '' ||
        sellerData["password"] == '') {
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
        await FirebaseFirestore.instance
            .collection("admin_request_database")
            .add(sellerData);

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        await FirebaseFirestore.instance
            .collection("seller_database")
            .add(sellerData);

        // clear textfield
        usernameController.clear();
        emailController.clear();
        passwordController.clear();

        // route
        Navigator.pushNamed(context, Routes.login);
      } catch (e) {
        log("error");
      }
    }
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
                  "Create Account",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                      label: Text(
                        "Username",
                      ),
                      border: OutlineInputBorder()),
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
                  obscureText: true,
                  decoration: const InputDecoration(
                      label: Text(
                        "Password",
                      ),
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: requestToAdmin,
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Request",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.login);
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
