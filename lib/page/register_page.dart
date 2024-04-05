import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  RegisterPage({super.key});

  // register method
  void register() {}

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

          // Welcome message
            Text(
              "Let's create an account for you",
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
              // password textfield
            const SizedBox(height: 10),
            myTextField(hintText: 'Password',
             obsecureText: true,
             controller: _pwController,
             ),

            //  const SizedBox(height: 25),

             const SizedBox(height: 10),
            myTextField(hintText: 'Confirm password',
             obsecureText: true,
             controller: _confirmPwController,
             ),

             const SizedBox(height: 25),

             MyButton(
              text: "Register",
              onTap: register,
             ),

             const SizedBox(height: 25),




             // register now
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text(
                  "Already have an account?",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                 ),
                 Text(
                  "Login now",
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