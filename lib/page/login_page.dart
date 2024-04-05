import 'package:badger_market/components/my_button.dart';
import 'package:badger_market/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  // email and pw text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  LoginPage({super.key});

  //login method
  void login() {}

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
            ImageIcon(
              AssetImage("assets/images/Bucky.png"),
              size: 100,
              color:Colors.red,
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
              onTap: login,
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
                 Text(
                  "Register now",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary
                  )
                 ),
               ],
             ),
             const SizedBox(height: 180),
        ],)
      ),
    );
  }
}