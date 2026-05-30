import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:khmerjobs/public/page/candidate_home.dart';
import 'package:khmerjobs/public/widget/input.dart';
import 'package:khmerjobs/public/page/register.dart';
import 'package:khmerjobs/public/controller/auth_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final storage = Get.find<FlutterSecureStorage>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D9E75),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('K', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('KhmerJobs', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('Welcome back', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Sign in to continue your job search', style: TextStyle(color: Color(0xFF888888), fontSize: 14)),
                const SizedBox(height: 40),
                const Text('Email', style: TextStyle(color: Color(0xFF888888), fontSize: 13)),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Email is required';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Password', style: TextStyle(color: Color(0xFF888888), fontSize: 13)),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password is required';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Obx(() => ElevatedButton(
                    onPressed: auth.isLoading.value 
                      ? null 
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            await auth.login(
                              _emailController.text.trim(),
                              _passwordController.text,
                            );

                            if (auth.userToken.value != null) {
                              // Save session
                              await storage.write(key: 'token', value: auth.userToken.value);
                              await storage.write(key: 'refreshtoken', value: auth.refreshToken.value);
                              await storage.write(key: 'userid', value: auth.userId.value);
                              await storage.write(key: 'role', value: auth.role.value);

                              Get.snackbar(
                                "Success", "Welcome back!",
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(15),
                              );

                              // Navigate based on role
                              if (auth.role.value == 'Employer') {
                                // Get.offAll(() => const EmployerDashboard()); 
                                Get.offAll(() => const CandidateHomeScreen()); // Fallback for now
                              } else {
                                Get.offAll(() => const CandidateHomeScreen());
                              }
                            } else {
                              Get.snackbar(
                                "Login Failed", 
                                auth.message.value.isNotEmpty ? auth.message.value : "Invalid email or password",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(15),
                              );
                            }
                          }
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D9E75),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF1D9E75).withOpacity(0.6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: auth.isLoading.value
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Login', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  )),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ", style: TextStyle(color: Color(0xFF888888), fontSize: 14)),
                    GestureDetector(
                      onTap: () => Get.to(() => const Register()),
                      child: const Text('Create one', style: TextStyle(color: Color(0xFF1D9E75), fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
