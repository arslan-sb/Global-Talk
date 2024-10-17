import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io'; // For File
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

class CustomProfileScreen extends StatefulWidget {
  const CustomProfileScreen({Key? key}) : super(key: key);

  @override
  _CustomProfileScreenState createState() => _CustomProfileScreenState();
}

class _CustomProfileScreenState extends State<CustomProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _genderController = TextEditingController();
  final _languageController = TextEditingController();

  User? user;
  bool isLoading = true;
  String? profileImageUrl;
  bool emailVerified = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    emailVerified = user?.emailVerified ?? false; // Check if the email is verified
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _usernameController.text = data['username'] ?? '';
          _genderController.text = data['gender'] ?? '';
          _languageController.text = data['language'] ?? '';
          profileImageUrl = data['profileImageUrl'] ?? '';
          isLoading = false;
        });
      }
    }
  }

  Future<void> updateUserData() async {
    if (user != null) {
      // Update Firestore user document
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'username': _usernameController.text.trim(),
        'gender': _genderController.text.trim(),
        'language': _languageController.text.trim(),
        'profileImageUrl': profileImageUrl ?? '',
      });

      // Update user in Firebase Chat Core
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: _usernameController.text.trim(), // Assuming first name is username
          id: user!.uid,
          imageUrl: profileImageUrl ?? 'https://i.pravatar.cc/300', // Default image if not provided
          lastName: '', // You can add last name field if you have it in your user model
        ),
      );
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await user!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print("before image loaded to picker");

    if (pickedFile != null && user != null) {
      print("image loaded to picker");
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(user!.uid)
            .child('profile.jpeg');

        // Set metadata to avoid null issues
        final metadata = SettableMetadata(
          contentType: 'image/jpeg', // Make sure the content type matches the file type
        );

        // Upload the image with metadata
        await storageRef.putFile(File(pickedFile.path), metadata);

        // Get download URL
        String downloadUrl = await storageRef.getDownloadURL();

        setState(() {
          profileImageUrl = downloadUrl;
        });

        // Update user document in Firestore with the new profile image URL
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'profileImageUrl': downloadUrl});
      } on FirebaseException catch (e) {
        print('Firebase error: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Firebase error: ${e.message}')),
        );
      } catch (e) {
        print('General error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _genderController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView( // Use SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Image
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: profileImageUrl != null && profileImageUrl!.isNotEmpty
                          ? NetworkImage(profileImageUrl!)
                          : null,
                      child: profileImageUrl == null || profileImageUrl!.isEmpty
                          ? const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickAndUploadImage,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blue,
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Email Field (Read-only)
                TextFormField(
                  initialValue: user?.email ?? '',
                  decoration: const InputDecoration(labelText: 'Email'),
                  enabled: false,
                ),
                const SizedBox(height: 16),

                // Verification button (only show if the email is not verified)
                if (!emailVerified)
                  ElevatedButton(
                    onPressed: () async {
                      await sendEmailVerification();
                    },
                    child: const Text('Verify Email'),
                  ),

                const SizedBox(height: 16),

                // Username Field
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Gender Field (Dropdown)
                DropdownButtonFormField<String>(
                  value: _genderController.text.isNotEmpty ? _genderController.text : null,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _genderController.text = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Language Field
                TextFormField(
                  controller: _languageController,
                  decoration: const InputDecoration(labelText: 'Language'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a language';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Save button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() == true) {
                      await updateUserData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated')),
                      );
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
