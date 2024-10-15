import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io'; // For File
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
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
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'username': _usernameController.text.trim(),
        'gender': _genderController.text.trim(),
        'language': _languageController.text.trim(),
        'profileImageUrl': profileImageUrl ?? '',
      });
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
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
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
                // Language Field (Dropdown)
                DropdownButtonFormField<String>(
                  value: _languageController.text.isNotEmpty ? _languageController.text : null,
                  decoration: const InputDecoration(labelText: 'Language'),
                  items: [
                    DropdownMenuItem(value: 'English', child: Text('English')),
                    DropdownMenuItem(value: 'Spanish', child: Text('German')),
                    // DropdownMenuItem(value: 'French', child: Text('French')),
                    // Add more languages as needed
                  ],
                  onChanged: (value) {
                    setState(() {
                      _languageController.text = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a language';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await updateUserData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated')),
                      );
                    }
                  },
                  child: const Text('Save Changes'),
                ),
                const SizedBox(height: 16),
                // Change Password Button
                ElevatedButton(
                  onPressed: () async {
                    if (user?.email != null) {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password reset email sent')),
                      );
                    }
                  },
                  child: const Text('Change Password'),
                ),
                const SizedBox(height: 16),
                // Delete Account Button
                ElevatedButton(
                  onPressed: () async {
                    // Confirm deletion
                    bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Account'),
                        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true && user != null) {
                      try {
                        // Delete user data from Firestore
                        await FirebaseFirestore.instance.collection('users').doc(user!.uid).delete();

                        // Delete user account
                        await user!.delete();

                        Navigator.of(context).popUntil((route) => route.isFirst);
                      } catch (e) {
                        // Handle errors, may need to re-authenticate
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to delete account: $e')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}