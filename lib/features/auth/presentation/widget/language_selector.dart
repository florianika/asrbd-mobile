import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LanguageSelector extends StatefulWidget {
  Function(String) onLanguageSelected;
  LanguageSelector(this.onLanguageSelected, {super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => widget.onLanguageSelected('sq'),
          child: CountryFlag.fromLanguageCode(
            'sq',
            width: 30,
            height: 20,
            shape: const RoundedRectangle(6),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => widget.onLanguageSelected('en'),
          child: CountryFlag.fromLanguageCode(
            'en',
            width: 30,
            height: 20,
            shape: const RoundedRectangle(6),
          ),
        ),
      ],
    );
  }
}
