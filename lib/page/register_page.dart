import 'package:badger_market/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  
  // Tap to go to Login Page
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  // register method
  void register(BuildContext context) async {
    //get auth service
    final _auth = AuthService();
    if (!_emailController.text.endsWith("@wisc.edu")) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("Invalid Email"),
          content: Text("Email must end with '@wisc.edu'"),
          actions: [
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      if (_pwController.text == _confirmPwController.text) {
        try {
          // Check for duplicate username and email
          QuerySnapshot usernameSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: _usernameController.text)
              .get();

          QuerySnapshot emailSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: _emailController.text)
              .get();

          List<String> errors = [];
          if (usernameSnapshot.docs.isNotEmpty) {
            errors.add("Username already exists!");
          }
          if (emailSnapshot.docs.isNotEmpty) {
            errors.add("Email already exists!");
          }

          if (errors.isNotEmpty) {
            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text("Registration Error"),
                content: Column(
                  children: errors.map((e) => Text(e)).toList(),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text("OK"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
            return;
          }

          UserCredential userCredential = await _auth.signUpWithEmailPassword(
            _emailController.text,
            _pwController.text,
          );

          User? user = userCredential.user;
          if (user != null) {
            await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
              'username': _usernameController.text,
              'email': _emailController.text,
              'created_at': FieldValue.serverTimestamp(),
            });

            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text("Registration Successful"),
                content: Text("Email has been sent! Please verify your email and log in!"),
                actions: [
                  CupertinoDialogAction(
                    child: Text("OK"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
          }
        } catch (e) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text("Error"),
              content: Text(e.toString()),
              actions: [
                CupertinoDialogAction(
                  child: Text("OK"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        }
      } else {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text("Password Mismatch"),
            content: Text("Passwords don't match!"),
            actions: [
              CupertinoDialogAction(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Badger Market"),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/Bucky.png',
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 50),
              Text(
                "Let's create an account for you",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 25),
              myTextField(
                hintText: 'Username',
                obsecureText: false,
                controller: _usernameController,
              ),
              const SizedBox(height: 10),
              myTextField(
                hintText: 'Email',
                obsecureText: false,
                controller: _emailController,
              ),
              const SizedBox(height: 10),
              myTextField(
                hintText: 'Password',
                obsecureText: true,
                controller: _pwController,
              ),
              const SizedBox(height: 10),
              myTextField(
                hintText: 'Confirm password',
                obsecureText: true,
                controller: _confirmPwController,
              ),
              const SizedBox(height: 25),
              MyButton(
                text: "Register",
                onTap: () => register(context),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Login now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 180),
            ],
          ),
        ),
      ),
    );
  }
}