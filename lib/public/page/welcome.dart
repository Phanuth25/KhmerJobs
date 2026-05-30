import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:khmerjobs/public/page/candidate_home.dart';
import 'package:khmerjobs/public/page/login.dart';
import 'package:khmerjobs/public/page/register.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String token = '';

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    const storage = FlutterSecureStorage();
    final value = await storage.read(key: 'token');
    setState(() {
      token = value ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Top badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2E1E),
                  border: Border.all(color: const Color(0xFF1D9E75)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, color: Color(0xFF1D9E75), size: 12),
                    SizedBox(width: 6),
                    Text(
                      '#1 job board in Cambodia',
                      style: TextStyle(color: Color(0xFF1D9E75), fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Logo row
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D9E75),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text(
                        'K',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Headline
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  children: [
                    TextSpan(
                      text: 'Find your dream job in ',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: 'Cambodia',
                      style: TextStyle(color: Color(0xFF1D9E75)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Connect with top companies hiring right now. Upload your CV and apply in seconds.',
                style: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),
              // Stats row
              Row(
                children: [
                  _statCard('500+', 'Active jobs'),
                  const SizedBox(width: 10),
                  _statCard('200+', 'Companies'),
                  const SizedBox(width: 10),
                  _statCard('10k+', 'Candidates'),
                ],
              ),
              const Spacer(),
              // login button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (token == 'candidate') {
                      Get.offAll(() => const CandidateHomeScreen());
                    } else if (token == '') {
                      Get.offAll(() => const Login());
                    } else {
                      Get.offAll(() => const CandidateHomeScreen());
                    }
                  },
                  icon: const Icon(Icons.rocket_launch, color: Colors.white),
                  label: const Text(
                    'Get started',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D9E75),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Sign in button
              ...[
                if (token == '')
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => Get.to(() => const Register()),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF333333)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 12, color: Color(0xFF444444)),
                    children: [
                      TextSpan(text: 'By continuing you agree to our '),
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(color: Color(0xFF1D9E75)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String number, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF222222)),
        ),
        child: Column(
          children: [
            Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF666666), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
