import 'package:flutter/material.dart';

import 'package:lms/core/constants/app_locale.dart';
import 'package:lms/core/extensions/string_extensions.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            const Text(
              'Choose your preferred language',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            RadioGroup<String>(
              groupValue: AppLocale.english.lang,
              onChanged: (_) {},
              child: Column(
                children: AppLocale.values.map((locale) {
                  return RadioListTile.adaptive(
                    value: locale.lang,
                    radioBackgroundColor: const WidgetStatePropertyAll(
                      Colors.white,
                    ),
                    activeColor: Colors.black,
                    title: Text(
                      locale.name.capitalize(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
