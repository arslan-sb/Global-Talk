// import 'package:flutter/material.dart';
// import 'package:global_talk_app/screens/signinOrSignUp/auth_gate.dart';
// import 'package:global_talk_app/screens/signinOrSignUp/signin.dart';
// import 'package:global_talk_app/screens/signinOrSignUp/signup.dart';
//
// import '../../components/primary_button.dart';
// import '../../constants.dart';
// import '../chats/chats_screen.dart';
//
// class SigninOrSignupScreen extends StatelessWidget {
//   const SigninOrSignupScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
//           child: Column(
//             children: [
//               const Spacer(flex: 2),
//           Center(
//             child: Image.asset(
//                 MediaQuery.of(context).platformBrightness == Brightness.light
//                     ? "assets/images/global.png"
//                     : "assets/images/global1.png",
//                 height: 246,
//               ),
//           ),
//               const Spacer(),
//               PrimaryButton(
//                 text: "Sign In",
//                 press: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const AuthGate(),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: kDefaultPadding * 1.5),
//               PrimaryButton(
//                 color: Theme.of(context).colorScheme.secondary,
//                 text: "Sign Up",
//                 press: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const SignUpScreen(),
//                   ),
//                 ),
//               ),
//               const Spacer(flex: 2),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
