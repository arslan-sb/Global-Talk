// import 'package:flutter/material.dart';
// import 'package:global_talk_app/screens/signinOrSignUp/signin.dart';
// import '../../components/primary_button.dart';
// import '../../constants.dart';
// import 'edit_profile.dart';
//
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile"),
//         backgroundColor: kPrimaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(kDefaultPadding),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Column(
//                 children: [
//                   const CircleAvatar(
//                     radius: 50,
//                     backgroundImage: AssetImage("assets/images/user_2.png"),
//                   ),
//                   const SizedBox(height: kDefaultPadding),
//                   Text(
//                     "User Name",
//                     style: Theme.of(context)
//                         .textTheme
//                         .headlineSmall!
//                         .copyWith(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: kDefaultPadding / 2),
//                   Text(
//                     "Email: user@example.com",
//                     style: Theme.of(context).textTheme.bodyLarge,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: kDefaultPadding),
//             PrimaryButton(
//               text: "Edit Profile",
//               press: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const EditProfileScreen(),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: kDefaultPadding / 2),
//             PrimaryButton(
//               text: "Log Out",
//               color: Colors.red,
//               press: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const SignInScreen(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
