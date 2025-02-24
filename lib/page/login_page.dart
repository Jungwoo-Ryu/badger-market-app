import 'package:badger_market/common/loading_widget.dart';
import 'package:badger_market/services/auth/auth_service.dart';
import 'package:badger_market/components/my_button.dart';
import 'package:badger_market/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
    final authService = AuthService();

    showLoadingDialog(context); // Show loading dialog

    try {
      await authService.signInWithEmailPassword(
        _emailController.text, _pwController.text);
      hideLoadingDialog(context); // Hide loading dialog on success
    } catch (e) {
      hideLoadingDialog(context); // Hide loading dialog on error
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Badger Market",),
          ],
        ),
      ),
      ),
        
      body: Center(
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
              "Welcome back, you've been missed!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              )
            ),
            const SizedBox(height:25),
            myTextField(
              hintText: 'Email', 
              obsecureText: false,
              controller: _emailController,
              ),
            const SizedBox(height: 10),
            myTextField(hintText: 'Password',
             obsecureText: true,
             controller: _pwController,
             ),
             const SizedBox(height: 25),
             MyButton(
              text: "Login",
              onTap: () => login(context),
             ),
             const SizedBox(height: 25),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text(
                  "Not a member? ",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                 ),
                 GestureDetector(
                  onTap: onTap,
                   child: Text(
                    "Register now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary
                    )
                   ),
                 ),
               ],
             ),
             const SizedBox(height: 180),
        ],)
      ),
    );
  }
}