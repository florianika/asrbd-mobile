import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:flutter/services.dart';

class UsernameField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const UsernameField({super.key, required this.controller, this.validator});

  @override
  State<UsernameField> createState() => _UsernameFieldState();
}

class _UsernameFieldState extends State<UsernameField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          SystemChannels.textInput.invokeMethod('TextInput.show');
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).translate(Keys.mailPlaceholder),
        prefixIcon: const Icon(FontAwesomeIcons.user),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: widget.validator,
    );
  }
}
