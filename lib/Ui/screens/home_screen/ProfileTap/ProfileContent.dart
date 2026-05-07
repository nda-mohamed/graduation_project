import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../FirebaseServices/profile_services.dart';
import '../../../../core/app_theme/AppColors.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final ProfileService profileService = ProfileService();

  bool pushNotifications = true;
  bool emailNotifications = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool dataLoaded = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> handleSaveProfile() async {
    try {
      await profileService.saveProfile(
        name: nameController.text,
        email: emailController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated Successfully")),
      );
    } catch (e) {
      print("Save Profile Error: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = profileService.currentUser;

    print("Current User UID: ${user?.uid}");

    if (user == null) {
      return const Center(
        child: Text(
          "User not logged in",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: profileService.getUserData(),

      builder: (context, snapshot) {
        print("Firestore Error: ${snapshot.error}");

        // ================= LOADING =================

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // ================= ERROR =================

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        // ================= NO DATA =================

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(
            child: Text(
              "User data not found",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        // تحميل البيانات مرة واحدة فقط

        if (!dataLoaded) {
          nameController.text = data['name'] ?? '';
          emailController.text = data['email'] ?? '';

          dataLoaded = true;
        }

        return Container(
          color: AppColor.background,

          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),

                // ================= PROFILE IMAGE =================
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

                // ================= NAME =================
                buildProfileField("Name :", nameController),

                const SizedBox(height: 16),

                // ================= EMAIL =================
                buildProfileField(
                  "Email :",
                  emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 30),

                // ================= PUSH NOTIFICATIONS =================
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

                // ================= EMAIL NOTIFICATIONS =================
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

                const SizedBox(height: 30),

                // ================= SAVE BUTTON =================
                ElevatedButton(
                  onPressed: handleSaveProfile,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.green6,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  child: const Text(
                    "Save Changes",

                    style: TextStyle(
                      color: AppColor.green1,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
