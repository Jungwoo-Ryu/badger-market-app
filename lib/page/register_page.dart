import 'package:badger_market/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  
  // Tap to go to Login Page
  final void Function()? onTap;


  RegisterPage({super.key, required this.onTap});

  // register method
  void register(BuildContext context) {
    //get auth service
    final _auth = AuthService();
    if(!_emailController.text.endsWith("@wisc.edu")){
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
          title: Text("email must end with '@wisc.edu'")
        ));
    } else {
      if(_pwController.text == _confirmPwController.text){
        try{
          _auth.signUpWithEmailPassword(
            _emailController.text, 
            _pwController.text,);
            showDialog(
            context: context,
            builder: (context) => AlertDialog(
            title: Text("Email has been sent! please verify your email and log in!"),
            ));
        } catch (e) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
            // title: Text(e.toString())
            title: Text(e.toString())
          ));
        }
      } 
      else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
            title: Text("Passwords don't match!")
          ));
      }

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
              onTap: () => register(context),
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
                 GestureDetector(
                  onTap: onTap,
                   child: Text(
                    "Login now",
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