import 'package:flutter/material.dart';
import 'package:flutter_founders/presentation/profile/edit_profile/edit_profile_form.dart';
import 'package:flutter_founders/presentation/profile/models/profile_model.dart';

class EditProfilePage extends StatelessWidget {
  final ProfileModel profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: EditProfileForm(profile: profile),
      ),
    );
  }
}
