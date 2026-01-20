import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1D24),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),

                _inputField(nameController, "Full Name", Icons.person),
                const SizedBox(height: 15),

                _inputField(emailController, "Email", Icons.email),
                const SizedBox(height: 15),

                _inputField(
                  passwordController,
                  "Password",
                  Icons.lock,
                  obscure: true,
                ),
                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _registerUser(
                        context,
                        nameController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                    },
                    child: const Text(
                      "REGISTER",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFF10131A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// 🔥 CORE LOGIC (THIS IS STEP 3.3.1)
  Future<void> _registerUser(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    try {
      // 1️⃣ Firebase Auth → Create User
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2️⃣ Get UID
      final uid = userCredential.user!.uid;

      final firestore = FirebaseFirestore.instance;

      // 3️⃣ Create users/{UID}
      await firestore.collection('users').doc(uid).set({
        "name": name,
        "email": email,
        "role": "student",
        "createdAt": FieldValue.serverTimestamp(),
      });

      // 4️⃣ Create devices/{UID}
      await firestore.collection('devices').doc(uid).set({
        "deviceName": "Unknown",
        "os": "Unknown",
        "lastSeen": FieldValue.serverTimestamp(),
      });

      // Success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful")),
      );

      // 5️⃣ Navigate back to Login
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
