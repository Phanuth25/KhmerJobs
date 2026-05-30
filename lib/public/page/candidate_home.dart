import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khmerjobs/public/controller/auth_controller.dart';
import 'package:khmerjobs/public/controller/jobs_controller.dart';
import 'package:khmerjobs/public/page/welcome.dart';

class CandidateHomeScreen extends StatefulWidget {
  const CandidateHomeScreen({super.key});

  @override
  State<CandidateHomeScreen> createState() => _CandidateHomeScreenState();
}

class _CandidateHomeScreenState extends State<CandidateHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final auth = Get.find<AuthController>();
  final jobs = Get.find<JobsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<JobsController>().fetchjob();
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log out alert'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('Are you sure you want to log out?')],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes', style: TextStyle(color: Colors.green)),
              onPressed: () {
                auth.logout();
                Get.offAll(() => const WelcomeScreen());
              },
            ),
            TextButton(
              child: const Text('No', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF0A0A0A),
      endDrawer: _buildDrawer(auth),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => jobs.fetchjob(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),
                      Obx(() => _buildGreeting(auth.name.value ?? '', jobs)),
                      const SizedBox(height: 12),
                      _buildSearchBar(),
                      const SizedBox(height: 12),
                      _buildFilterChips(),
                      const SizedBox(height: 14),
                      _buildSectionHeader('Featured jobs', 'See all'),
                      const SizedBox(height: 8),
                      Obx(() {
                        if (jobs.isLoading.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(
                                color: Color(0xFF1D9E75),
                              ),
                            ),
                          );
                        }

                        // Show error message if one exists
                        if (jobs.message.value.isNotEmpty &&
                            jobs.message.value != "successful" &&
                            jobs.jobs.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.redAccent,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Error: ${jobs.message.value}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => jobs.fetchjob(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1D9E75),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Try Again'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (jobs.jobs.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                'No jobs available',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: jobs.jobs.length,
                          itemBuilder: (context, index) {
                            final job = jobs.jobs[index];
                            return _buildJobCard(
                              logo: job.companyName.isNotEmpty
                                  ? job.companyName[0].toUpperCase()
                                  : 'J',
                              logoColor: const Color(0xFF1A2E1E),
                              logoTextColor: const Color(0xFF1D9E75),
                              title: job.title,
                              company: job.companyName,
                              type: job.type,
                              location: job.location,
                              salary: '\$${job.salaryMin}–\$${job.salaryMax}',
                              time: job.createdAt,
                            );
                          },
                        );
                      }),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF1F1F1F), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF1D9E75),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'K',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'KhmerJobs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF888888),
            size: 22,
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            child: const Icon(
              Icons.account_circle_outlined,
              color: Color(0xFF888888),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(AuthController auth) {
    return Drawer(
      backgroundColor: const Color(0xFF0A0A0A),
      child: Column(
        children: [
          Obx(
            () => UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF141414)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: const Color(0xFF1D9E75),
                child: Text(
                  auth.name.value != null && auth.name.value!.isNotEmpty
                      ? auth.name.value![0].toUpperCase()
                      : 'U',
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              accountName: Text(
                auth.name.value ?? 'User Name',
                style: const TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                auth.email.value ?? 'user@example.com',
                style: const TextStyle(color: Color(0xFF888888)),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Color(0xFF888888)),
            title: const Text('Profile', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.settings_outlined,
              color: Color(0xFF888888),
            ),
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
          const Spacer(),
          const Divider(color: Color(0xFF1F1F1F)),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'Log out',
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              _showMyDialog();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGreeting(String name, JobsController jobs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning, $name 👋',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${jobs.jobs.length} new jobs today in Phnom Penh',
          style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF222222), width: 0.5),
      ),
      child: Row(
        children: const [
          Icon(Icons.search, color: Color(0xFF555555), size: 18),
          SizedBox(width: 8),
          Text(
            'Search jobs, companies...',
            style: TextStyle(color: Color(0xFF555555), fontSize: 13),
          ),
          Spacer(),
          Icon(Icons.tune, color: Color(0xFF555555), size: 18),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Full-time', 'Remote', 'Part-time'];
    return SizedBox(
      height: 28,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 7),
        itemBuilder: (_, i) {
          final isSelected = i == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1A2E1E) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF1D9E75)
                    : const Color(0xFF333333),
                width: 0.5,
              ),
            ),
            child: Text(
              filters[i],
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? const Color(0xFF1D9E75)
                    : const Color(0xFF888888),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          action,
          style: const TextStyle(color: Color(0xFF1D9E75), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildJobCard({
    required String logo,
    required Color logoColor,
    required Color logoTextColor,
    required String title,
    required String company,
    required String type,
    required String location,
    required String salary,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF222222), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: logoColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    logo,
                    style: TextStyle(
                      color: logoTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      company,
                      style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.bookmark_border,
                color: Color(0xFF444444),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 5,
            children: [
              _buildTag(type, const Color(0xFF0D1F35), const Color(0xFF4D9DE0)),
              _buildTag(
                location,
                const Color(0xFF1A1A1A),
                const Color(0xFF666666),
              ),
              _buildTag(
                salary,
                const Color(0xFF1A2E1E),
                const Color(0xFF1D9E75),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: const TextStyle(color: Color(0xFF444444), fontSize: 10),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D9E75),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Text(
                  'Quick apply',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 10)),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      [Icons.home_outlined, 'Home', true],
      [Icons.search, 'Search', false],
      [Icons.description_outlined, 'Applied', false],
      [Icons.bookmark_border, 'Saved', false],
      [Icons.person_outline, 'Profile', false],
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        border: Border(top: BorderSide(color: Color(0xFF1F1F1F), width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          final icon = item[0] as IconData;
          final label = item[1] as String;
          final isActive = item[2] as bool;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive
                    ? const Color(0xFF1D9E75)
                    : const Color(0xFF666666),
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? const Color(0xFF1D9E75)
                      : const Color(0xFF666666),
                  fontSize: 10,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
