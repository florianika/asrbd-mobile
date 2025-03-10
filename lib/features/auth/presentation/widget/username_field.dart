import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const UsernameField({super.key, required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText:
            (AppLocalizations.of(context).translate(Keys.mailPlaceholder)),
        prefixIcon: const Icon(FontAwesomeIcons.user),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: validator,
    );
  }
}
