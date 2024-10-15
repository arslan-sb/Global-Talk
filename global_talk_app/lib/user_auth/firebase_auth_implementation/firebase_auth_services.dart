import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Firestore for storing additional user info
import '../../../global/common/toast.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance for storing user profiles

  Future<User?> signUpWithEmailAndPassword(String email, String password, String username) async {
    try {
      // Sign up the user with email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      print("abbb");
      print(user);

      if (user != null) {
        print("User registered: ${user.uid}");

        // Store the additional user information (username) in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'username': username,  // Store username in Firestore
          'createdAt': FieldValue.serverTimestamp(),
        });

        showToast(message: 'Sign up successful!');
        return user;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    } catch (e) {
      print("Error: $e");
      showToast(message: 'An unexpected error occurred. Please try again.');
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }
}
