import 'package:flutter/material.dart';
import 'package:global_talk_app/screens/signinOrSignUp/signin.dart';
import '../../constants.dart';
import '../../components/primary_button.dart';
import '../../components/filled_outline_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ensures the layout adjusts when the keyboard is open
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          // Wraps the content in a scrollable view
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kDefaultPadding * 2), // Extra spacing at the top
                Center(
                  child: Image.asset(
                    MediaQuery.of(context).platformBrightness == Brightness.light
                        ? "assets/images/global.png"
                        : "assets/images/global1.png",
                    height: 246,
                  ),
                ),
                Text(
                  "Sign Up",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: kDefaultPadding),
                // Username field
                TextField(
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                // Email field
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                // Password field
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                // Confirm Password field
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: kDefaultPadding * 1.5),
                PrimaryButton(
                  text: "Sign Up",
                  press: () {
                    // Handle sign-up logic
                  },
                ),
                const SizedBox(height: kDefaultPadding * 2), // Adjusted spacing at the bottom
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    FillOutlineButton(
                      isFilled: true,
                      text: "Sign In",
                      press: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kDefaultPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
