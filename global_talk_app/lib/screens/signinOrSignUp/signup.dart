// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:global_talk_app/screens/signinOrSignUp/signin.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';  // Add this to store username in Firestore
//
// import '../../components/primary_button.dart';
// import '../../components/filled_outline_button.dart';
// import '../../constants.dart';
// import '../../../global/common/toast.dart'; // Assuming you have a toast method for displaying messages
// import '../../user_auth/firebase_auth_implementation/firebase_auth_services.dart';
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   final FirebaseAuthService _auth = FirebaseAuthService();
//
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   bool _isSigningUp = false;
//
//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Spacer(flex: 2),
//               Center(
//                 child: Image.asset(
//                   MediaQuery.of(context).platformBrightness == Brightness.light
//                       ? "assets/images/global.png"
//                       : "assets/images/global1.png",
//                   height: 246,
//                 ),
//               ),
//               Text(
//                 "Sign Up",
//                 style: Theme.of(context)
//                     .textTheme
//                     .headlineSmall!
//                     .copyWith(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: kDefaultPadding),
//               TextField(
//                 controller: _usernameController,
//                 decoration: InputDecoration(
//                   labelText: "Username",
//                   labelStyle: TextStyle(
//                     color: Theme.of(context).textTheme.bodyLarge!.color,
//                   ),
//                   border: const OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: kDefaultPadding),
//               TextField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: "Email",
//                   labelStyle: TextStyle(
//                     color: Theme.of(context).textTheme.bodyLarge!.color,
//                   ),
//                   border: const OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: kDefaultPadding),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: "Password",
//                   labelStyle: TextStyle(
//                     color: Theme.of(context).textTheme.bodyLarge!.color,
//                   ),
//                   border: const OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: kDefaultPadding * 1.5),
//               GestureDetector(
//                 onTap: _isSigningUp ? null : _signUp, // Disable tap if signing up
//                 child: Container(
//                   width: double.infinity,
//                   height: 45,
//                   decoration: BoxDecoration(
//                     color: _isSigningUp ? Colors.grey : kPrimaryColor,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Center(
//                     child: _isSigningUp
//                         ? const CircularProgressIndicator(
//                       color: Colors.white,
//                     )
//                         : const Text(
//                       "Sign Up",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ),
//               const Spacer(flex: 2),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Already have an account? ",
//                     style: TextStyle(
//                       color: Theme.of(context).textTheme.bodyLarge!.color,
//                     ),
//                   ),
//                   FillOutlineButton(
//                     isFilled: true,
//                     text: "Sign In",
//                     press: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const SignInScreen(),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Sign-up logic using Firebase authentication
//   void _signUp() async {
//     setState(() {
//       _isSigningUp = true;
//     });
//
//     String username = _usernameController.text.trim();
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//
//     // Input validation
//     if (username.isEmpty || email.isEmpty || password.isEmpty) {
//       showToast(message: "Please fill out all fields.");
//       setState(() {
//         _isSigningUp = false;
//       });
//       return;
//     }
//
//     // Call the Firebase authentication sign-up function with username
//     var user = await _auth.signUpWithEmailAndPassword(email, password, username); // Updated to pass the username
//     print("User: $user");
//
//     setState(() {
//       _isSigningUp = false;
//     });
//
//     if (user != null) {
//       showToast(message: "Sign up successful!");
//       // Navigate to the next screen after successful sign-up
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const SignInScreen(), // Adjust to your home or next screen
//         ),
//       );
//     } else {
//       showToast(message: "Some error occurred. Please try again.");
//     }
//   }
// }
