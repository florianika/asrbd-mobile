import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PasswordField({super.key, required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText:
            (AppLocalizations.of(context).translate(Keys.passwordPlaceholder)),
        prefixIcon: const Icon(FontAwesomeIcons.lock),
      ),
      obscureText: true,
      validator: validator,
    );
  }
}
