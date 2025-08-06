import 'package:flutter/material.dart';
import 'package:flutter_founders/data/api/profile_api_service.dart';
import 'package:flutter_founders/presentation/profile/models/profile_model.dart';
import 'widgets/edit_profile_header.dart';
import 'widgets/edit_text_field.dart';
import 'widgets/edit_profile_submit_button.dart';

class EditProfileForm extends StatefulWidget {
  final ProfileModel profile;

  const EditProfileForm({super.key, required this.profile});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController bioController;
  late TextEditingController companyInfoController;
  late TextEditingController companyNameController;
  late TextEditingController companyIndustryController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.profile.name.split(' ').first,
    );
    surnameController = TextEditingController(
      text: widget.profile.name.split(' ').skip(1).join(' '),
    );
    emailController = TextEditingController(text: widget.profile.email ?? '');
    phoneController = TextEditingController(text: widget.profile.phone ?? '');
    bioController = TextEditingController(text: widget.profile.bio ?? '');
    companyInfoController = TextEditingController(
      text: widget.profile.companyInfo ?? '',
    );
    companyNameController = TextEditingController(
      text: widget.profile.companyName ?? '',
    );
    companyIndustryController = TextEditingController(
      text: widget.profile.industry ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    companyInfoController.dispose();
    companyNameController.dispose();
    companyIndustryController.dispose();
    super.dispose();
  }

  void submit() async {
    if (nameController.text.trim().isEmpty ||
        surnameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Please enter both first name and surname'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final updatedProfile = ProfileModel(
      id: widget.profile.id,
      name: '${nameController.text.trim()} ${surnameController.text.trim()}',
      email: emailController.text.trim(),
      avatarUrl: widget.profile.avatarUrl,
      companyName: companyNameController.text.trim(),
      industry: companyIndustryController.text.trim(),
      bio: bioController.text.trim(),
      companyInfo: companyInfoController.text.trim(),
      phone: phoneController.text.trim(),
      userPartners: widget.profile.userPartners,
      isPartner: widget.profile.isPartner,
    );

    try {
      await ProfileApiService().updateProfile(updatedProfile);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Profile updated successfully')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      print('❌ Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Failed to update profile: $e')));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditProfileHeader(profile: widget.profile),
              const SizedBox(height: 24),
              EditTextField(label: 'Имя', controller: nameController),
              EditTextField(label: 'Фамилия', controller: surnameController),
              EditTextField(
                label: 'Email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              EditTextField(
                label: 'Телефон',
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
              EditTextField(
                label: 'Имя компании',
                controller: companyNameController,
              ),
              EditTextField(
                label: 'Сфера деятельности',
                controller: companyIndustryController,
              ),
              EditTextField(
                label: 'О себе',
                controller: bioController,
                maxLines: 5,
              ),
              EditTextField(
                label: 'О компании',
                controller: companyInfoController,
                maxLines: 5,
              ),
              const SizedBox(height: 12),
              EditProfileSubmitButton(onPressed: submit, isLoading: isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
