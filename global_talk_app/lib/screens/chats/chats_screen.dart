import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_talk_app/screens/profile/profile_screen.dart'; // Import ProfileScreen
import '../../constants.dart';
import 'components/body.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _selectedIndex = 0; // Set initial index to 0 (Chats)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _selectedIndex == 0 ? const Body() : Container(), // Show Body() when Chats is selected
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.person_add_alt_1,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;

          if (value == 1) {
            // Navigate to ProfileScreen when "Profile" tab is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  appBar: AppBar(
                    title: const Text('User Profile'),
                  ),
                  actions: [
                    SignedOutAction((context) {
                      Navigator.of(context).pop();
                    })
                  ],
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: AspectRatio(
                        aspectRatio: 2,
                        child: Image.asset('assets/images/global.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ).then((_) {
              // Reset the selected index to 0 (Chats) when returning from ProfileScreen
              setState(() {
                _selectedIndex = 0;
              });
            });
          }
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.messenger),
          label: "Chats",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      automaticallyImplyLeading: false,
      title: const Text("Chats"),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}
