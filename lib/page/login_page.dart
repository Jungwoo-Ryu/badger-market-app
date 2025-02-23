import 'package:badger_market/services/auth/auth_service.dart';
import 'package:badger_market/components/my_button.dart';
import 'package:badger_market/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  // email and pw text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

// tap to go to register page
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  //login method
  void login(BuildContext context) async {
    //auth service
    final authService = AuthService();

    // try login
    try {
      await authService.signInWithEmailPassword(
        _emailController.text, _pwController.text);
    }
    // catch errors
    catch (e) {
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(e.toString())
      ));
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
            // Logo
            // Icon(
            //   Icons.message,
            //   size: 60,
            //   color: Theme.of(context).colorScheme.primary,
            // ),

            const SizedBox(height: 50),

          // Welcome back message
            Text(
              "Welcome back, you've been missed!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              )
            ),

            const SizedBox(height:25),

            // email textfield
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
              // style: const Color.fromRGBO(161, 32, 43, 1), // Set button color
              onTap: () => login(context),
             ),

             const SizedBox(height: 25),

             // register now
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