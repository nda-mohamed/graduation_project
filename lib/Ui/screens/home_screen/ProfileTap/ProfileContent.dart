import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/app_theme/AppColors.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  bool pushNotifications = true;
  bool emailNotifications = true;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> autoSave() async {
    final user = auth.currentUser;
    if (user != null) {
      await firestore.collection('users').doc(user.uid).set({
        'name': nameController.text,
        'country': countryController.text,
        'email': emailController.text,
      }, SetOptions(merge: true));
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(autoSave);
    countryController.addListener(autoSave);
    emailController.addListener(autoSave);
  }

  @override
  void dispose() {
    nameController.dispose();
    countryController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: firestore.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final rawData = snapshot.data!.data();
        if (rawData == null) {
          return const Scaffold(
            body: Center(child: Text("User data not found")),
          );
        }
        final data = rawData as Map<String, dynamic>;

        if (nameController.text.isEmpty)
          nameController.text = data['name'] ?? '';
        if (countryController.text.isEmpty)
          countryController.text = data['country'] ?? '';
        if (emailController.text.isEmpty)
          emailController.text = data['email'] ?? '';

        return Scaffold(
          backgroundColor: AppColor.background,
          appBar: AppBar(
            backgroundColor: AppColor.background,
            // actions: [
            //   IconButton(
            //     icon: const Icon(
            //       Icons.settings_outlined,
            //       color: AppColor.green6,
            //       size: 28,
            //     ),
            //     onPressed: () {},
            //   ),
            // ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.green6, width: 5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/profile/iconamoon_profile.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                buildProfileField("Name :", nameController),

                // const SizedBox(height: 16),
                // buildProfileField("Country :", countryController),
                const SizedBox(height: 16),

                buildProfileField(
                  "Email :",
                  emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 40),

                SwitchListTile(
                  title: const Text(
                    "Push Notifications",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: pushNotifications,
                  activeColor: AppColor.green5,
                  onChanged: (value) {
                    setState(() {
                      pushNotifications = value;
                    });
                  },
                ),

                SwitchListTile(
                  title: const Text(
                    "Email Notifications",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: emailNotifications,
                  activeColor: AppColor.green5,
                  onChanged: (value) {
                    setState(() {
                      emailNotifications = value;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildProfileField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColor.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(
                color: AppColor.green8,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: controller.text.isEmpty ? label : null,
                hintStyle: const TextStyle(color: AppColor.green6),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: AppColor.green6,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: AppColor.green6,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
