import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khmerjobs/public/widget/input.dart';
import 'package:khmerjobs/public/controller/auth_controller.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  // Observable for selected position
  final _selectedPosition = 'candidate'.obs;

  @override
  Widget build(BuildContext context) {
    final auth = Get.put(AuthController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D9E75),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      'K',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'KhmerJobs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Find your next opportunity in Cambodia',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  // Wrap selection with Obx
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectedPosition.value = 'candidate',
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selectedPosition.value == 'candidate'
                                      ? const Color(0xFF1D9E75)
                                      : Colors.white24,
                                  width: _selectedPosition.value == 'candidate'
                                      ? 2
                                      : 1,
                                ),
                                color: _selectedPosition.value == 'candidate'
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person,
                                    color:
                                        _selectedPosition.value == 'candidate'
                                        ? const Color(0xFF1D9E75)
                                        : Colors.white70,
                                    size: 40,
                                  ),
                                  Text(
                                    'Candidate',
                                    style: TextStyle(
                                      color:
                                          _selectedPosition.value == 'candidate'
                                          ? Colors.white
                                          : Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectedPosition.value = 'employer',
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selectedPosition.value == 'employer'
                                      ? const Color(0xFF1D9E75)
                                      : Colors.white24,
                                  width: _selectedPosition.value == 'employer'
                                      ? 2
                                      : 1,
                                ),
                                color: _selectedPosition.value == 'employer'
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.business_center_outlined,
                                    color: _selectedPosition.value == 'employer'
                                        ? const Color(0xFF1D9E75)
                                        : Colors.white70,
                                    size: 40,
                                  ),
                                  Text(
                                    'Employer',
                                    style: TextStyle(
                                      color:
                                          _selectedPosition.value == 'employer'
                                          ? Colors.white
                                          : Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            CustomTextField(
              controller: _nameController,
              labelText: 'Full name',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _emailController,
              labelText: 'Email',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _phoneController,
              labelText: 'Phone number',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: auth.isLoading.value
                        ? null
                        : () async {
                            await auth.register(
                              _nameController.text,
                              _emailController.text,
                              _passwordController.text,
                              _phoneController.text,
                              _selectedPosition.value,
                            );
                            if (auth.message.value == "successfully") {
                              Get.snackbar(
                                "Success",
                                "Registered successfully, please click on sign in to login",
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            } else if (auth.message.value.isNotEmpty) {
                              Get.snackbar(
                                "Error",
                                auth.message.value,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D9E75),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: auth.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Create account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: Color(0xFF1D9E75),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
