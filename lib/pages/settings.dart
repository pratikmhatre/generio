import 'package:flutter/material.dart';
import 'package:generio/utils/shared_prefs_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final profileDetailsController = TextEditingController();
  @override
  void initState() {
    _checkSavedProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          frameTitle('Add Your Profile Here'),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(8),
            child: ColoredBox(
              color: Color(0xffeeeeee),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextField(
                  controller: profileDetailsController,
                  maxLines: 10,
                  style: TextStyle(fontSize: 14.0),
                  decoration: InputDecoration(
                    hintText: 'Paster your profile details here..',
                    border: OutlineInputBorder(),
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              FilledButton(
                onPressed: () {
                  _saveProfileData();
                },
                child: Text('Save'),
              ),
              SizedBox(width: 16),
              OutlinedButton(
                onPressed: () {
                  _resetProfileData();
                },
                child: Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _resetProfileData() {
    profileDetailsController.text = '';
    SharedPrefsProvider().profileInfo = '';
  }

  _saveProfileData() {
    SharedPrefsProvider().profileInfo = profileDetailsController.text;
  }

  _checkSavedProfileData() {
    profileDetailsController.text = SharedPrefsProvider().profileInfo;
  }

  Widget frameTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
